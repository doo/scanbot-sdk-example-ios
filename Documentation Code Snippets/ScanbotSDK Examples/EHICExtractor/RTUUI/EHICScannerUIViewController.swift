//
//  EHICRecognizerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

import UIKit
import ScanbotSDK

class EHICRecognizerUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUIHealthInsuranceCardRecognizerConfiguration.defaultConfiguration

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

        // Present the view controller modally.
        SBSDKUIHealthInsuranceCardRecognizerViewController.present(on: self,
                                                                configuration: configuration,
                                                                delegate: self)
    }
}

extension EHICRecognizerUIViewController: SBSDKUIHealthInsuranceCardRecognizerViewControllerDelegate {
    func healthInsuranceCardDetectionViewController(_ viewController: SBSDKUIHealthInsuranceCardRecognizerViewController,
                                                    didDetectCard card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        // Process the detected card.
    }
}
