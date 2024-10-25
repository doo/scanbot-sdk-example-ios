//
//  MedicalCertificateRecognizerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

import UIKit
import ScanbotSDK

class MedicalCertificateRecognizerUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    private func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUIMedicalCertificateRecognizerConfiguration.defaultConfiguration
        
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
        SBSDKUIMedicalCertificateRecognizerViewController.present(on: self,
                                                                  configuration: configuration,
                                                                  delegate: self)
    }
}

extension MedicalCertificateRecognizerUIViewController: SBSDKUIMedicalCertificateRecognizerViewControllerDelegate {
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateRecognizerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateRecognitionResult) {
        // Process the scanned result.
    }
    
    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateRecognizerViewController) {
        // Handle canceling the scanner screen.
    }
}
