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
    
    do {
        
        // Create an instance of medical certificate scanner.
        let scanner = try SBSDKMedicalCertificateScanner.create()
        
        // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
        let scanParameters = SBSDKMedicalCertificateScanningParameters()
        
        // Enable the medical certificate image extraction.
        scanParameters.extractCroppedImage = true
        
        // Customize the parameters as needed.
        scanParameters.shouldCropDocument = true
        scanParameters.recognizePatientInfoBox = true
        scanParameters.recognizeBarcode = true
        scanParameters.preprocessInput = false
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run the scanner on the image using the configured parameters.
        let result = try scanner.run(image: imageRef, parameters: scanParameters)
        
        // Get the cropped image.
        let croppedImage = try result.croppedImage?.toUIImage()
    }
    catch {
        print("Error scanning medical certificate: \(error.localizedDescription)")
    }
}
