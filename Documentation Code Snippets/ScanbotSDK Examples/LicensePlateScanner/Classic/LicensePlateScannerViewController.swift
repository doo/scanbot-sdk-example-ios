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

        // Create the SBSDKLicensePlateScannerConfiguration object.
        let configuration = SBSDKLicensePlateScannerConfiguration()

        // Set the maximum number of accumulated frames before starting recognition.
        configuration.maximumNumberOfAccumulatedFrames = 5

        // Create the SBSDKLicensePlateScannerViewController instance.
        self.scannerViewController = SBSDKLicensePlateScannerViewController(parentViewController: self,
                                                                            parentView: self.view,
                                                                            configuration: configuration,
                                                                            delegate: self)
    }

}

extension LicensePlateScannerViewController: SBSDKLicensePlateScannerViewControllerDelegate {
    func licensePlateScannerViewController(_ controller: SBSDKLicensePlateScannerViewController,
                                           didRecognizeLicensePlate licensePlateResult: SBSDKLicensePlateScannerResult,
                                           on image: UIImage) {
        // Process the recognized result.
    }
}
