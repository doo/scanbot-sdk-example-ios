//
//  TextPatternScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

import UIKit
import ScanbotSDK

class TextPatternScannerUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUITextPatternScannerConfiguration.defaultConfiguration
        
        // Behavior configuration:
        // e.g. enable highlighting of the detected word boxes.
        configuration.behaviorConfiguration.wordBoxHighlightEnabled = true
        
        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white
        
        // Text configuration:
        // e.g. customize a UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"
        
        // Create the data scanner step.
        let step = SBSDKUITextPatternScannerStep()
        
        // Set the finder's unzoomed height.
        step.unzoomedFinderHeight = 100
        
        // Set the aspect ratio.
        step.aspectRatio = SBSDKAspectRatio(width: 4.0, height: 1.0)
        
        // Set the guidance text.
        step.guidanceText = "Scan a document"
        
        configuration.behaviorConfiguration.scanningStep = step
        // Present the view controller modally.
        SBSDKUITextPatternScannerViewController.present(on: self,
                                                        configuration: configuration,
                                                        delegate: self)
    }
}

extension TextPatternScannerUIViewController: SBSDKUITextPatternScannerViewControllerDelegate {
    
    func textPatternScannerViewController(_ controller: SBSDKUITextPatternScannerViewController,
                                          didFinish step: SBSDKUITextPatternScannerStep,
                                          with result: SBSDKUITextPatternScannerStepResult) {
        // Process the recognized result.
    }
}
