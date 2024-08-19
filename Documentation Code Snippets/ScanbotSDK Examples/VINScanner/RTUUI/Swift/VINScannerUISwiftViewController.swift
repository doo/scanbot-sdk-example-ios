//
//  VINScannerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import UIKit
import ScanbotSDK

class VINScannerUISwiftViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUIVINScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. set the maximum number of accumulated frames.
        configuration.behaviorConfiguration.maximumNumberOfAccumulatedFrames = 4

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white

        // Text configuration:
        // e.g. customize a UI element's text.
        configuration.textConfiguration.guidanceText = "Scan Vin"
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the scanner view controller modally on this view controller.
        SBSDKUIVINScannerViewController.present(on: self,
                                                configuration: configuration,
                                                delegate: self)
    }
}

extension VINScannerUISwiftViewController: SBSDKUIVINScannerViewControllerDelegate {
    func vinScannerViewController(_ viewController: SBSDKUIVINScannerViewController,
                                  didFinishWith result: SBSDKVehicleIdentificationNumberScannerResult) {
        // Process the result.
    }
}
