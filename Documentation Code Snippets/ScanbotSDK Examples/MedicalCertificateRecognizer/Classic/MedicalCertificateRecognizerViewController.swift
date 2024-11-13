//
//  MedicalCertificateRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

import UIKit
import ScanbotSDK

class MedicalCertificateRecognizerViewController: UIViewController {

    // The instance of the recognizer view controller.
    var recognizerViewController: SBSDKMedicalCertificateRecognizerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an instance of `SBSDKMedicalCertificateRecognitionParameters` with default values.
        let recognitionParameters = SBSDKMedicalCertificateRecognitionParameters()

        // Customize the parameters as needed.
        recognitionParameters.shouldCropDocument = true
        recognitionParameters.recognizePatientInfoBox = true
        recognitionParameters.recognizeBarcode = true
        recognitionParameters.extractCroppedImage = false
        recognitionParameters.preprocessInput = false
        
        // Create the `SBSDKMedicalCertificateRecognizerViewController` instance and embed it.
        self.recognizerViewController = SBSDKMedicalCertificateRecognizerViewController(parentViewController: self,
                                                                                        parentView: self.view,
                                                                                        recognitionParameters: recognitionParameters,
                                                                                        delegate: self)
    }
}

extension MedicalCertificateRecognizerViewController: SBSDKMedicalCertificateRecognizerViewControllerDelegate {
    
    func medicalCertificateRecognizerViewController(_ controller: SBSDKMedicalCertificateRecognizerViewController,
                                                    didRecognizeMedicalCertificate result: SBSDKMedicalCertificateRecognitionResult) {
        // Process the recognized result.
    }
}
