//
//  MRZScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class MRZScannerViewController: UIViewController {
        
    // The instance of the recognition view controller.
    private var scannerViewController: SBSDKMRZScannerViewController?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default configuration object.
        let configuration = SBSDKMRZScannerConfiguration()
        
        // Create the SBSDKMRZScannerViewController instance.
        self.scannerViewController = SBSDKMRZScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
}

extension MRZScannerViewController: SBSDKMRZScannerViewControllerDelegate {
    func mrzScannerController(_ controller: SBSDKMRZScannerViewController, didDetectMRZ result: SBSDKMRZScannerResult) {
        // Process the recognized result.
    }
}

