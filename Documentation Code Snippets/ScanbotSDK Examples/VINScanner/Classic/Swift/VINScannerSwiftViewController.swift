//
//  VINScannerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import UIKit
import ScanbotSDK

class VINScannerSwiftViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKVINScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the default SBSDKVehicleIdentificationNumberScannerConfiguration object.
        let configuration = SBSDKVehicleIdentificationNumberScannerConfiguration.defaultConfiguration

        // Create the VINScannerViewController instance.
        self.scannerViewController = SBSDKVINScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
}

extension VINScannerSwiftViewController: SBSDKVINScannerViewControllerDelegate {
    func vinScannerViewController(_ controller: SBSDKVINScannerViewController,
                                  didScanValidResult result: SBSDKVehicleIdentificationNumberScannerResult) {
        // Process the result.
    }
}
