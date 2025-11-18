//
//  ScanAndCountViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 20.06.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class ScanAndCountViewController: UIViewController {
    private enum Segue: String {
        case showResults
        case showTypesSelection
    }
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var listCountLabel: UILabel!
    
    private var countedBarcodes = [SBSDKBarcodeScannerAccumulatingResult]()
    private var selectedBarcodeTypes: [SBSDKBarcodeFormat] = SBSDKBarcodeFormats.all
    private var scannerViewController: SBSDKBarcodeScanAndCountViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: selectedBarcodeTypes)
        
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        self.scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                            parentView: self.containerView,
                                                                            configuration: configuration,
                                                                            delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showResults.rawValue {
            if let destination = segue.destination as? ScanAndCountResultsViewController {
                destination.countedBarcodes = countedBarcodes
            }
        } else if segue.identifier == Segue.showTypesSelection.rawValue {
            if let controller = segue.destination as? BarcodeTypesViewController {
                controller.selectedTypes = selectedBarcodeTypes
                controller.delegate = self
            }
        }
    }
    
    @IBAction func listButtonTapped(_ sender: Any) {
        guard !countedBarcodes.isEmpty else { return }
        performSegue(withIdentifier: Segue.showResults.rawValue , sender: self)
    }
}

extension ScanAndCountViewController: SBSDKBarcodeScanAndCountViewControllerDelegate {
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             didScanBarcodes codes: [SBSDKBarcodeItem]) {
        codes.forEach { code in
            guard let existingCode = self.countedBarcodes.first(where: {
                $0.item.format.name == code.format.name && $0.item.textWithExtension == code.textWithExtension
            }) else {
                self.countedBarcodes.append(SBSDKBarcodeScannerAccumulatingResult(barcodeItem: code))
                return
            }
            existingCode.scanCount += 1
            existingCode.dateOfLastScanning = Date()
        }
        let count = countedBarcodes.reduce(0) { $0 + $1.scanCount }
        listCountLabel.text = String(count)
    }
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController, didFailScanning error: any Error) {
        sbsdk_showError(error)
    }
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             overlayForBarcode code: SBSDKBarcodeItem) -> UIView? {
        UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    }
}

extension ScanAndCountViewController: BarcodeTypesViewControllerDelegate {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeFormat]) {
        guard let scannerViewController else { return }
        selectedBarcodeTypes = types
        let configuration = scannerViewController.configuration
        configuration.barcodeFormatConfigurations = [SBSDKBarcodeFormatCommonConfiguration(formats: selectedBarcodeTypes)]
        scannerViewController.configuration = configuration
    }
}
