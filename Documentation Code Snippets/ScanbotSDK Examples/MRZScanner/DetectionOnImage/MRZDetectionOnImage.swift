//
//  MRZDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func scanMRZOnImage() {
    
    // The image containing the machine-readable-zone.
    guard let image = UIImage(named: "mrzImage") else { return }
    
    // Create the default configuration.
    let configuration = SBSDKMRZScannerConfiguration()
    
    // Customize the configuration as needed.
    
    // Enable the document detection.
    configuration.enableDetection = true
    
    // Customize the frame accumulation configuration as needed.
    configuration.frameAccumulationConfiguration.maximumNumberOfAccumulatedFrames = 3
    configuration.frameAccumulationConfiguration.minimumNumberOfRequiredFramesWithEqualScanningResult = 2
    
    // Whether to accept or reject incomplete MRZ results.
    configuration.incompleteResultHandling = .accept
    
    do {
        
        // Create an instance of MRZ scanner using the configuration.
        let scanner = try SBSDKMRZScanner(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run the scanner on the image.
        let result = try scanner.run(image: imageRef)
    }
    catch {
        print("Error scanning MRZ: \(error.localizedDescription)")
    }
}
