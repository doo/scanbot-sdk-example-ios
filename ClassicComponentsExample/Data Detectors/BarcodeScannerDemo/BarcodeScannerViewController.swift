//
//  BarcodeScannerViewController.swift
//  ClassicComponentsExample
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
    
    var selectedBarcodeTypes: [SBSDKBarcodeFormat] = SBSDKBarcodeFormats.all
    var currentResults: [SBSDKBarcodeItem]?
    var shouldScan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: selectedBarcodeTypes)
        
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: view, 
                                                                  configuration: configuration,
                                                                  delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldScan = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldScan = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.showResults.rawValue {
            if let controller = segue.destination as? BarcodeScannerResultsViewController {
                controller.results = currentResults
                currentResults = nil
            }
        } else if segue.identifier == Segue.showTypesSelection.rawValue {
            if let controller = segue.destination as? BarcodeTypesViewController {
                controller.selectedTypes = selectedBarcodeTypes
                controller.delegate = self
            }
        }
    }
    
    func displayResults(_ codes: [SBSDKBarcodeItem]) {
        currentResults = codes
        performSegue(withIdentifier: Segue.showResults.rawValue, sender: nil)
    }
}

extension BarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    func barcodeScannerControllerShouldScanBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return shouldScan
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController, didScanBarcodes codes: [SBSDKBarcodeItem]) {
        if !shouldScan { return }
        if (!controller.isTrackingOverlayEnabled) {
            shouldScan = false
            displayResults(codes)
        }
    }
}

extension BarcodeScannerViewController: BarcodeTypesViewControllerDelegate {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeFormat]) {
        guard let scannerViewController else { return }
        selectedBarcodeTypes = types
        let configuration = scannerViewController.copyCurrentConfiguration()
        configuration.barcodeFormatConfigurations = [SBSDKBarcodeFormatCommonConfiguration(formats: selectedBarcodeTypes)]
        scannerViewController.setConfiguration(configuration)
    }
}
