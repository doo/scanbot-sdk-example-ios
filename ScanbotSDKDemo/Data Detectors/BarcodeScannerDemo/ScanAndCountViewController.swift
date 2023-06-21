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
    private var detectedBarcodes: [SBSDKBarcodeScannerResult] = []
    private var shouldRecognizeBarcodes = true
    private var selectedBarcodeTypes: [SBSDKBarcodeType] = SBSDKBarcodeType.allTypes()
    private var scannerViewController: SBSDKBarcodeScanAndCountViewController!
    private var selectedBarcode: SBSDKBarcodeScannerResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                        parentView: self.containerView,
                                                                        delegate: self)
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showResults.rawValue {
            if let controller = segue.destination as? BarcodeScannerResultsViewController {
                guard let selectedBarcode else { return }
                controller.results = [selectedBarcode]
                self.selectedBarcode = nil
            }
        } else if segue.identifier == Segue.showTypesSelection.rawValue {
            if let controller = segue.destination as? BarcodeTypesViewController {
                controller.selectedTypes = selectedBarcodeTypes
                controller.delegate = self
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.shouldRecognizeBarcodes = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.shouldRecognizeBarcodes = false
    }
}

extension ScanAndCountViewController: SBSDKBarcodeScanAndCountViewControllerDelegate {
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController, didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        detectedBarcodes = codes
    }
    
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController, overlayForBarcode code: SBSDKBarcodeScannerResult) -> UIView? {
        let button = UIButton()
        let image = UIImage(systemName: "checkmark.circle.fill")
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        button.tintColor = .green
        if let index = detectedBarcodes.firstIndex(of: code) {
            button.tag = index
        }
        button.addTarget(self, action: #selector(barcodeButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func barcodeButtonTapped(_ sender: UIButton) {
        if sender.tag < detectedBarcodes.count {
            selectedBarcode = detectedBarcodes[sender.tag]
            if selectedBarcode != nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: Segue.showResults.rawValue, sender: self)
                }
            }
        }
    }
}

extension ScanAndCountViewController: BarcodeTypesViewControllerDelegate {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeType]) {
        selectedBarcodeTypes = types
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
    }
}
