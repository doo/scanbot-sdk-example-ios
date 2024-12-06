//
//  MRZScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class MRZScannerViewController: UIViewController {
        
    // The instance of the scanner view controller.
    private var scannerViewController: SBSDKMRZScannerViewController?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default configuration.
        let configuration = SBSDKMRZScannerConfiguration()
        
        // Customize the configuration as needed.
        
        // Enable the document detection.
        configuration.enableDetection = true
        
        // Customize the frame accumulation configuration as needed.
        configuration.frameAccumulationConfiguration.maximumNumberOfAccumulatedFrames = 3
        configuration.frameAccumulationConfiguration.minimumNumberOfRequiredFramesWithEqualRecognitionResult = 2
        
        // Whether to accept or reject incomplete MRZ results.
        configuration.incompleteResultHandling = .accept
        
        // Create the `SBSDKMRZScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKMRZScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
}

extension MRZScannerViewController: SBSDKMRZScannerViewControllerDelegate {
    
    func mrzScannerController(_ controller: SBSDKMRZScannerViewController, didScanMRZ result: SBSDKMRZScannerResult) {
        // Process the recognized result.
    }
}

