//
//  CheckRecognizerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

import UIKit
import ScanbotSDK

class CheckRecognizerUISwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    private func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUICheckRecognizerConfiguration.defaultConfiguration
        
        // Behavior configuration:
        // e.g. disable capturing the photo to recognize on live video stream
        configuration.behaviorConfiguration.captureHighResolutionImage = false
        
        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        
        // Text configuration:
        // e.g. customize UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUICheckRecognizerViewController.present(on: self,
                                                     configuration: configuration,
                                                     delegate: self)
    }
}

extension CheckRecognizerUISwiftViewController: SBSDKUICheckRecognizerViewControllerDelegate {
    func checkRecognizerViewController(_ viewController: SBSDKUICheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognizerResult) {
        // Process the recognized result.
    }
    
    func checkRecognizerViewControllerDidCancel(_ viewController: SBSDKUICheckRecognizerViewController) {
        // Handle dismissing of the recognizer view controller.
    }
}
