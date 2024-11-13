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
    configuration.frameAccumulationConfiguration.minimumNumberOfRequiredFramesWithEqualRecognitionResult = 2
    
    // Whether to accept or reject incomplete MRZ results.
    configuration.incompleteResultHandling = .accept
    
    // Create an instance of `SBSDKMRZScanner` using the configuration.
    let scanner = SBSDKMRZScanner(configuration: configuration)
    
    // Run the scanner on the image.
    let result = scanner.scanMRZ(on: image)
}
