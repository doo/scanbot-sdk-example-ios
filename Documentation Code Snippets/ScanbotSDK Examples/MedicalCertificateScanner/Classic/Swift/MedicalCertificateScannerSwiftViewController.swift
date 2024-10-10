//
//  MedicalCertificateScannerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

import UIKit
import ScanbotSDK

class MedicalCertificateScannerSwiftViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKMedicalCertificateScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SBSDKMedicalCertificateScannerViewController instance.
        self.scannerViewController = SBSDKMedicalCertificateScannerViewController(parentViewController: self,
                                                                                  parentView: self.view,
                                                                                  delegate: self)
    }
}

extension MedicalCertificateScannerSwiftViewController: SBSDKMedicalCertificateScannerViewControllerDelegate {
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didRecognizeMedicalCertificate result: SBSDKMedicalCertificateRecognizerResult) {
        // Process the recognized result.
    }
}
