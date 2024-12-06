//
//  LicensePlateScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.06.21.
//

import UIKit
import ScanbotSDK

class LicensePlateScannerViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKLicensePlateScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the default configuration object.
        let configuration = SBSDKLicensePlateScannerConfiguration()

        // Customize the configuration as needed.
        configuration.scannerStrategy = .ml
        configuration.maximumNumberOfAccumulatedFrames = 3
        configuration.minimumNumberOfRequiredFramesWithEqualScanningResult = 2

        // Create the `SBSDKLicensePlateScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKLicensePlateScannerViewController(parentViewController: self,
                                                                            parentView: self.view,
                                                                            configuration: configuration,
                                                                            delegate: self)
    }

}

extension LicensePlateScannerViewController: SBSDKLicensePlateScannerViewControllerDelegate {
    
    func licensePlateScannerViewController(_ controller: SBSDKLicensePlateScannerViewController,
                                           didScanLicensePlate licensePlateResult: SBSDKLicensePlateScannerResult,
                                           on image: UIImage) {
        // Process the recognized result.
    }
}
