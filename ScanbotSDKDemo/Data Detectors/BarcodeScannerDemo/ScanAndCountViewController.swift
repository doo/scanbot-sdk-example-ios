//
//  ScanAndCountViewController.swift
//  ScanbotSDKDemo
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
    private var selectedBarcodeTypes: [SBSDKBarcodeType] = SBSDKBarcodeType.allTypes()
    private var scannerViewController: SBSDKBarcodeScanAndCountViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                        parentView: self.containerView,
                                                                        delegate: self)
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
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
                             didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        codes.forEach { code in
            guard let existingCode = self.countedBarcodes.first(where: {
                $0.code.type == code.type && $0.code.rawTextString == code.rawTextString
            }) else {
                self.countedBarcodes.append(SBSDKBarcodeScannerAccumulatingResult(barcodeResult: code))
                return
            }
            existingCode.scanCount += 1
            existingCode.code.dateOfDetection = code.dateOfDetection
        }
        let count = countedBarcodes.reduce(0) { $0 + $1.scanCount }
        listCountLabel.text = String(count)
    }
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             overlayForBarcode code: SBSDKBarcodeScannerResult) -> UIView? {
        UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    }
}

extension ScanAndCountViewController: BarcodeTypesViewControllerDelegate {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeType]) {
        selectedBarcodeTypes = types
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
    }
}
