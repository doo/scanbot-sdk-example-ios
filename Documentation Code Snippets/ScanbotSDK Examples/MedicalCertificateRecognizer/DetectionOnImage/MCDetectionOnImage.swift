//
//  MCDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK
    
func detectMedicalCertificateOnImage() {
    
    // Image containing Medical Certificate.
    guard let image = UIImage(named: "medicalCertificateImage") else { return }
    
    // Create the default configuration object.
    let configuration = SBSDKMedicalCertificateRecognitionParameters()
    
    // Creates an instance of `SBSDKMedicalCertificateRecognizer`.
    let detector = SBSDKMedicalCertificateRecognizer()
    
    // Returns the result after running detector on the image.
    let result = detector.recognizeMedicalCertificate(on: image, parameters: configuration)

}
