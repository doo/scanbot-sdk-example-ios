//
//  LicensePlateScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 04.06.21.
//

import UIKit
import ScanbotSDK

class LicensePlateScannerUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUILicensePlateScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. set the maximum number of accumulated frames before starting recognition.
        configuration.behaviorConfiguration.maximumNumberOfAccumulatedFrames = 5

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        configuration.uiConfiguration.topBarButtonsInactiveColor = UIColor.white.withAlphaComponent(0.3)

        // Text configuration:
        // e.g. customize a UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the view controller modally.
        SBSDKUILicensePlateScannerViewController.present(on: self,
                                                         configuration: configuration,
                                                         delegate: self)
    }
}

extension LicensePlateScannerUIViewController: SBSDKUILicensePlateScannerViewControllerDelegate {
    func licensePlateScanner(_ controller: SBSDKUILicensePlateScannerViewController,
                             didRecognizeLicensePlate result: SBSDKLicensePlateScannerResult) {
        // Process the scanned result.
    }
}
