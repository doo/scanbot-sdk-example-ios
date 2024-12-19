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
    
    // Create an instance of `SBSDKCheckScanner`.
    let scanner = SBSDKCheckScanner()
    
    // Set the desired check types to the scanner.
    scanner.acceptedCheckTypes = SBSDKCheckDocumentModelRootType.allDocumentTypes
    
    // Scan the check from given image.
    let result = scanner.scan(from: image)
}
