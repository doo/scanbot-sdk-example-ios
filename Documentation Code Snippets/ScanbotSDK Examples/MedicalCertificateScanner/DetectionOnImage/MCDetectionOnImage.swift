//
//  MCDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func scanMedicalCertificateFromImage() {
    
    // The image containing a medical certificate.
    guard let image = UIImage(named: "medicalCertificateImage") else { return }
    
    // Create an instance of `SBSDKMedicalCertificateScanner`.
    let scanner = SBSDKMedicalCertificateScanner()
    
    // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
    let scanParameters = SBSDKMedicalCertificateScanningParameters()
    
    // Enable the medical certificate image extraction.
    scanParameters.extractCroppedImage = true
    
    // Customize the parameters as needed.
    scanParameters.shouldCropDocument = true
    scanParameters.recognizePatientInfoBox = true
    scanParameters.recognizeBarcode = true
    scanParameters.preprocessInput = false
    
    // Run the scanner on the image using the configured parameters.
    let result = scanner.scan(from: image, parameters: scanParameters)
    
    // Get the cropped image.
    let croppedImage = result?.croppedImage?.toUIImage()
}
