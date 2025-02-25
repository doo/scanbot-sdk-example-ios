//
//  CheckScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

import UIKit
import ScanbotSDK

class CheckScannerUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    private func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUICheckScannerConfiguration.defaultConfiguration
        
        // Behavior configuration:
        // e.g. disable capturing the photo to scan on live video stream
        configuration.behaviorConfiguration.captureHighResolutionImage = false
        
        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        
        // Text configuration:
        // e.g. customize UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"
        
        // Present the view controller modally.
        SBSDKUICheckScannerViewController.present(on: self,
                                                  configuration: configuration,
                                                  delegate: self)
    }
}

extension CheckScannerUIViewController: SBSDKUICheckScannerViewControllerDelegate {
    func checkScannerViewController(_ viewController: SBSDKUICheckScannerViewController,
                                    didScanCheck result: SBSDKCheckScanningResult) {
        // Process the scanned result.
    }
    
    func checkScannerViewControllerDidCancel(_ viewController: SBSDKUICheckScannerViewController) {
        // Handle dismissing of the scanner view controller.
    }
}
