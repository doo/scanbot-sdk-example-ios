//
//  BarcodeScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BarcodeScannerViewController: UIViewController {
    private enum Segue: String {
        case showResults
        case showTypesSelection
    }
    var scannerViewController: SBSDKBarcodeScannerViewController?
    private var selectedBarcodeTypes: [SBSDKBarcodeType] = []
    private var currentResults: [SBSDKBarcodeScannerResult]?
    
    private var shouldDetect: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: view,
                                                                  feature: FeatureQRCode)
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
        scannerViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldDetect = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldDetect = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showResults.rawValue {
            if let controller = segue.destination as? BarcodeScannerResultsViewController {
                controller.results = currentResults
            }
        } else if segue.identifier == Segue.showTypesSelection.rawValue {
            if let controller = segue.destination as? BarcodeTypesViewController {
                controller.selectedTypes = selectedBarcodeTypes
                controller.delegate = self
            }
        }
    }
}

extension BarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return shouldDetect
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        shouldDetect = false
        currentResults = codes
        performSegue(withIdentifier: Segue.showResults.rawValue, sender: nil)
    }
}

extension BarcodeScannerViewController: BarcodeTypesViewControllerDelegate {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeType]) {
        selectedBarcodeTypes = types
        scannerViewController?.acceptedBarcodeTypes = selectedBarcodeTypes
    }
}
