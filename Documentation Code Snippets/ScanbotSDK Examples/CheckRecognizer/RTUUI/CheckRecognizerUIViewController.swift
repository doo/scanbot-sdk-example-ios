//
//  CheckRecognizerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

import UIKit
import ScanbotSDK

class CheckRecognizerUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Present the view controller modally.
        SBSDKUICheckRecognizerViewController.present(on: self,
                                                     configuration: configuration,
                                                     delegate: self)
    }
}

extension CheckRecognizerUIViewController: SBSDKUICheckRecognizerViewControllerDelegate {
    func checkRecognizerViewController(_ viewController: SBSDKUICheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognitionResult) {
        // Process the recognized result.
    }
    
    func checkRecognizerViewControllerDidCancel(_ viewController: SBSDKUICheckRecognizerViewController) {
        // Handle dismissing of the recognizer view controller.
    }
}
