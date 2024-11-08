//
//  CheckDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func detectCheckOnImage() {
    
    // Image containing Check.
    guard let image = UIImage(named: "checkImage") else { return }
    
    // Creates an instance of `SBSDKCheckRecognizer`.
    let detector = SBSDKCheckRecognizer()
    
    // Type of checks that needs to be detected.
    let acceptedCheckTypes = SBSDKCheckDocumentModelRootType.allDocumentTypes
    
    // Set the types of check on detector.
    detector.acceptedCheckTypes = acceptedCheckTypes
    
    // Returns the result after running detector on the image.
    let result = detector.recognizeCheck(on: image)
}
