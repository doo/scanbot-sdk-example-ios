//
//  VINScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import UIKit
import ScanbotSDK

class VINScannerUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

        // Present the view controller modally.
        SBSDKUIVINScannerViewController.present(on: self,
                                                configuration: configuration,
                                                delegate: self)
    }
}

extension VINScannerUIViewController: SBSDKUIVINScannerViewControllerDelegate {
    func vinScannerViewController(_ controller: SBSDKUIVINScannerViewController,
                                  didFinishWith result: SBSDKGenericTextLineScannerResult) {
        // Process the result.
    }
}
