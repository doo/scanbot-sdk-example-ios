//
//  MRZScannerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class MRZScannerSwiftViewController: UIViewController {
        
    // The instance of the recognition view controller.
    private var scannerViewController: SBSDKMRZScannerViewController?
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKMRZScannerViewController instance.
        self.scannerViewController = SBSDKMRZScannerViewController(parentViewController: self,
                                                                   parentView: self.view,
                                                                   delegate: self)
    }
}

extension MRZScannerSwiftViewController: SBSDKMRZScannerViewControllerDelegate {
    func mrzScannerController(_ controller: SBSDKMRZScannerViewController, didDetectMRZ result: SBSDKMachineReadableZoneRecognizerResult) {
        // Process the recognized result.
    }
}

