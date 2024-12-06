//
//  MedicalCertificateScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

import UIKit
import ScanbotSDK

class MedicalCertificateScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKMedicalCertificateScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
        let recognitionParameters = SBSDKMedicalCertificateScanningParameters()
        
        // Customize the parameters as needed.
        recognitionParameters.shouldCropDocument = true
        recognitionParameters.recognizePatientInfoBox = true
        recognitionParameters.recognizeBarcode = true
        recognitionParameters.extractCroppedImage = false
        recognitionParameters.preprocessInput = false
        
        // Create the `SBSDKMedicalCertificateRecognizerViewController` instance and embed it.
        self.scannerViewController = SBSDKMedicalCertificateScannerViewController(parentViewController: self,
                                                                                  parentView: self.view,
                                                                                  scannerParameters: recognitionParameters,
                                                                                  delegate: self)
    }
}

extension MedicalCertificateScannerViewController: SBSDKMedicalCertificateScannerViewControllerDelegate {
    
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didScanMedicalCertificate result: SBSDKMedicalCertificateScanningResult) {
        // Process the scanned result.
    }
}
