//
//  EHICRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class EHICRecognizerViewController: UIViewController {
    
    // The instance of the recognition view controller.
    private var scannerViewController: SBSDKHealthInsuranceCardRecognizerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKHealthInsuranceCardScannerViewController instance.
        self.scannerViewController = SBSDKHealthInsuranceCardRecognizerViewController(parentViewController: self,
                                                                                   parentView: self.view,
                                                                                   delegate: self)
    }
}

extension EHICRecognizerViewController: SBSDKHealthInsuranceCardRecognizerViewControllerDelegate {
    func healthInsuranceCardRecognizerViewController(_ viewController: SBSDKHealthInsuranceCardRecognizerViewController,
                                                  didScanHealthInsuranceCard card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        // Process the recognized result.
    }
}
