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
    
    // Create an instance of `SBSDKMedicalCertificateScanner`.
    let recognizer = SBSDKMedicalCertificateScanner()
    
    // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
    let scanParameters = SBSDKMedicalCertificateScanningParameters()
    
    // Customize the parameters as needed.
    scanParameters.shouldCropDocument = true
    scanParameters.recognizePatientInfoBox = true
    scanParameters.recognizeBarcode = true
    scanParameters.extractCroppedImage = false
    scanParameters.preprocessInput = false
    
    // Run the scanner on the image using the configured parameters.
    let result = recognizer.scan(from: image, parameters: scanParameters)
    
}
