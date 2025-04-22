//
//  MedicalCertificateScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

import UIKit
import ScanbotSDK

class MedicalCertificateScannerUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    private func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUIMedicalCertificateScannerConfiguration.defaultConfiguration
        
        // Behavior configuration:
        // e.g. disable scanning of patient's personal information.
        configuration.behaviorConfiguration.isPatientInfoExtracted = false
        
        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        
        // Text configuration:
        // e.g. customize UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"
        
        // Present the view controller modally.
        SBSDKUIMedicalCertificateScannerViewController.present(on: self,
                                                               configuration: configuration,
                                                               delegate: self)
    }
}

extension MedicalCertificateScannerUIViewController: SBSDKUIMedicalCertificateScannerViewControllerDelegate {
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateScannerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateScanningResult) {
        // Process the scanned result.
    }
    
    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateScannerViewController) {
        // Handle canceling the scanner screen.
    }
}
