//
//  VINScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import UIKit
import ScanbotSDK

class VINScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKVINScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of the configuration for vehicle identification numbers.
        let configuration = SBSDKVINScannerConfiguration()
        
        // Enable extraction of VIN from barcode.
        configuration.extractVINFromBarcode = true
        
        // Create the `SBSDKVINScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKVINScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
}

extension VINScannerViewController: SBSDKVINScannerViewControllerDelegate {
    
    func vinScannerViewController(_ controller: SBSDKVINScannerViewController,
                                  didScanVIN result: SBSDKVINScannerResult) {
        
        // Process the result.
        
        // If `extractVINFromBarcode` from the configuration is set to `True`, you must check the barcode result first.
        if result.barcodeResult.status == .success && !result.barcodeResult.extractedVIN.isEmpty {
            print(result.barcodeResult.extractedVIN)
            
        // else check the text result.
        } else if result.textResult.validationSuccessful && !result.textResult.rawText.isEmpty {
            print(result.textResult.rawText)
        }
    }
}
