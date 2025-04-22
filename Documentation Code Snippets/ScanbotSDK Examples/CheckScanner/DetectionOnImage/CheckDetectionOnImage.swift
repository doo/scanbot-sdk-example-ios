//
//  CheckDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func scanCheckFromImage() {
    
    // The image containing a check.
    guard let image = UIImage(named: "checkImage") else { return }
    
    // Create a configuration with `detectAndCropDocument` to extract the check image.
    let configuration = SBSDKCheckScannerConfiguration(documentDetectionMode: .detectAndCropDocument)
    
    // Set the desired check types of the scanner.
    let acceptedCheckTypes = SBSDKCheckDocumentModelRootType.allDocumentTypes
    
    // Create an instance of `SBSDKCheckScanner`.
    let scanner = SBSDKCheckScanner(configuration: configuration, acceptedCheckTypes: acceptedCheckTypes)
    
    // Scan the check from given image.
    let result = scanner.scan(from: image)
    
    // Get the cropped image.
    let croppedImage = result?.croppedImage?.toUIImage()
}
