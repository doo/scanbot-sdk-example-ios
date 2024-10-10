//
//  EHICScannerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class EHICScannerSwiftViewController: UIViewController {
    
    // The instance of the recognition view controller.
    private var scannerViewController: SBSDKHealthInsuranceCardScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKHealthInsuranceCardScannerViewController instance.
        self.scannerViewController = SBSDKHealthInsuranceCardScannerViewController(parentViewController: self,
                                                                                   parentView: self.view,
                                                                                   delegate: self)
    }
}

extension EHICScannerSwiftViewController: SBSDKHealthInsuranceCardScannerViewControllerDelegate {
    func healthInsuranceCardScannerViewController(_ viewController: SBSDKHealthInsuranceCardScannerViewController,
                                                  didScanHealthInsuranceCard card: SBSDKHealthInsuranceCardRecognitionResult) {
        // Process the recognized result.
    }
}
