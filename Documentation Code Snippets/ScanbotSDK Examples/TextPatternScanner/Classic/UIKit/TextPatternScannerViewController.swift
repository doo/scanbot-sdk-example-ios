//
//  TextPatternScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

import UIKit
import ScanbotSDK

class TextPatternScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKTextPatternScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default `SBSDKTextPatternScannerConfiguration` object.
        let configuration = SBSDKTextPatternScannerConfiguration()
        
        // Create the `SBSDKTextPatternScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKTextPatternScannerViewController(parentViewController: self,
                                                                           parentView: self.view,
                                                                           configuration: configuration,
                                                                           delegate: self)
    }
}

extension TextPatternScannerViewController: SBSDKTextPatternScannerViewControllerDelegate {
    
    func textPatternScannerViewController(_ controller: SBSDKTextPatternScannerViewController,
                                          didScanTextPattern result: SBSDKTextPatternScannerResult) {
        // Process the scanned result.
    }
    
    func textPatternScannerViewController(_ controller: SBSDKTextPatternScannerViewController,
                                          didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning text pattern: \(error.localizedDescription)")
    }
}
