//
//  MCDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK
    
func recognizeMedicalCertificateOnImage() {
    
    // The image containing a medical certificate.
    guard let image = UIImage(named: "medicalCertificateImage") else { return }
    
    // Create an instance of `SBSDKMedicalCertificateRecognizer`.
    let recognizer = SBSDKMedicalCertificateRecognizer()
    
    // Create an instance of `SBSDKMedicalCertificateRecognitionParameters` with default values.
    let recognitionParameters = SBSDKMedicalCertificateRecognitionParameters()

    // Customize the parameters as needed.
    recognitionParameters.shouldCropDocument = true
    recognitionParameters.recognizePatientInfoBox = true
    recognitionParameters.recognizeBarcode = true
    recognitionParameters.extractCroppedImage = false
    recognitionParameters.preprocessInput = false
    
    // Run the recognizer on the image using the configured parameters.
    let result = recognizer.recognizeMedicalCertificate(on: image, parameters: recognitionParameters)

}
