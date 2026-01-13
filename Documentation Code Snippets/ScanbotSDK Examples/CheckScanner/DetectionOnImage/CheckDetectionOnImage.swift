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
    
    // Create a configuration with `detectAndCropDocument` and
    // the desired check types of the scanner to extract the check image.
    let configuration = SBSDKCheckScannerConfiguration(
        documentDetectionMode: .detectAndCropDocument,
        acceptedCheckStandards: [.usa, .fra, .aus, .can]
    )
    
    do {
        
        // Create an instance of the check scanner.
        let scanner = try SBSDKCheckScanner(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Scan the check from the given image.
        let result = try scanner.run(image: imageRef)
        
        // Get the cropped image.
        let croppedImage = try result.croppedImage?.toUIImage()
    }
    catch {
        print("Error scanning check: \(error.localizedDescription)")
    }
}
