//
//  EHICScannerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

import UIKit
import ScanbotSDK

class EHICScannerUISwiftViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUIHealthInsuranceCardScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. turn on the flashlight.
        configuration.behaviorConfiguration.isFlashEnabled = true

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red

        // Text configuration:
        // e.g. customize some UI elements' text.
        configuration.textConfiguration.flashButtonTitle = "Flash"
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUIHealthInsuranceCardScannerViewController.present(on: self,
                                                                configuration: configuration,
                                                                delegate: self)
    }
}

extension EHICScannerUISwiftViewController: SBSDKUIHealthInsuranceCardScannerViewControllerDelegate {
    func healthInsuranceCardDetectionViewController(_ viewController: SBSDKUIHealthInsuranceCardScannerViewController,
                                                    didDetectCard card: SBSDKHealthInsuranceCardRecognitionResult) {
        // Process the detected card.
    }
}
