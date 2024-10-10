//
//  MedicalCertificateScannerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

import UIKit
import ScanbotSDK

class MedicalCertificateScannerUISwiftViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    private func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUIMedicalCertificateScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. disable recognition of patient's personal information.
        configuration.behaviorConfiguration.isPatientInfoExtracted = false

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white

        // Text configuration:
        // e.g. customize UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUIMedicalCertificateScannerViewController.present(on: self,
                                                               configuration: configuration,
                                                               delegate: self)
    }
}

extension MedicalCertificateScannerUISwiftViewController: SBSDKUIMedicalCertificateScannerViewControllerDelegate {
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateScannerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateRecognizerResult) {
        // Process the scanned result.
    }

    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateScannerViewController) {
        // Handle canceling the scanner screen.
    }
}
