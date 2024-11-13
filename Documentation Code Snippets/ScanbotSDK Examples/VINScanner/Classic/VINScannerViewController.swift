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
        let configuration = SBSDKGenericTextLineScannerConfiguration.vehicleIdentificationNumber()
        
        // Create the `VINScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKVINScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
}

extension VINScannerViewController: SBSDKVINScannerViewControllerDelegate {
    
    func vinScannerViewController(_ controller: SBSDKVINScannerViewController,
                                  didScanValidResult result: SBSDKGenericTextLineScannerResult) {
        // Process the result.
    }
}
