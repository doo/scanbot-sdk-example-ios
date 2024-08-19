//
//  MRZScannerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 21.05.21.
//

import UIKit
import ScanbotSDK

class MRZScannerUISwiftViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUIMRZScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. enable a beep sound on successful detection.
        configuration.behaviorConfiguration.isSuccessBeepEnabled = true

        // UI configuration:
        // e.g. configure various colors and the finder's aspect ratio.
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 1, height: 0.25)

        // Text configuration:
        // e.g. customize some UI elements' text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"
        configuration.textConfiguration.flashButtonTitle = "Flash"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUIMRZScannerViewController.present(on: self, configuration: configuration, delegate: self)
    }
}

extension MRZScannerUISwiftViewController: SBSDKUIMRZScannerViewControllerDelegate {
    func mrzDetectionViewController(_ viewController: SBSDKUIMRZScannerViewController,
                                    didDetect zone: SBSDKMachineReadableZoneRecognizerResult) {
        // Process the detected result.
    }
}
