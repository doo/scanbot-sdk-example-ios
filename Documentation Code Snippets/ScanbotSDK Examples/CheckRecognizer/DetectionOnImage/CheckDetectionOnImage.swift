//
//  CheckDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func recognizeCheckOnImage() {
    
    // The image containing a check.
    guard let image = UIImage(named: "checkImage") else { return }
    
    // Create an instance of `SBSDKCheckRecognizer`.
    let recognizer = SBSDKCheckRecognizer()
    
    // Set the desired check types on the recognizer.
    recognizer.acceptedCheckTypes = SBSDKCheckDocumentModelRootType.allDocumentTypes
    
    // Run the recognizer on the image.
    let result = recognizer.recognizeCheck(on: image)
}
