//
//  MedicalCertificateRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

import UIKit
import ScanbotSDK

class MedicalCertificateRecognizerViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKMedicalCertificateRecognizerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SBSDKMedicalCertificateScannerViewController instance.
        self.scannerViewController = SBSDKMedicalCertificateRecognizerViewController(parentViewController: self,
                                                                                  parentView: self.view,
                                                                                  delegate: self)
    }
}

extension MedicalCertificateRecognizerViewController: SBSDKMedicalCertificateRecognizerViewControllerDelegate {
    
    func medicalCertificateRecognizerViewController(_ controller: SBSDKMedicalCertificateRecognizerViewController,
                                                    didRecognizeMedicalCertificate result: SBSDKMedicalCertificateRecognitionResult) {
        // Process the recognized result.
    }
}
