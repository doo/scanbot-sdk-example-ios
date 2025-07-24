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
    
    // Customize the default accepted check types as needed.
    // For this example we will use the following types of check.
    configuration.acceptedCheckStandards = [.usa, .uae, .fra, .isr, .kwt, .aus, .ind, .can]
    
    // Create an instance of `SBSDKCheckScanner`.
    let scanner = SBSDKCheckScanner(configuration: configuration)
    
    // Scan the check from given image.
    let result = scanner.scan(from: image)
    
    // Get the cropped image.
    let croppedImage = result?.croppedImage?.toUIImage()
}
