//
//  LicensePlateDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 11.11.24.
//

import Foundation
import ScanbotSDK

func scanLicensePlateOnImage() {
    
    // The image containing a license plate.
    guard let image = UIImage(named: "licensePlateImage") else { return }
    
    // Create the default configuration.
    let configuration = SBSDKLicensePlateScannerConfiguration()

    // Customize the configuration as needed.
    configuration.scannerStrategy = .ml
    configuration.maximumNumberOfAccumulatedFrames = 3
    configuration.minimumNumberOfRequiredFramesWithEqualScanningResult = 2
    
    // Create an instance of `SBSDKLicensePlateScanner` using the configuration.
    let scanner = SBSDKLicensePlateScanner(configuration: configuration)
    
    // Run the scanner on the image.
    let result = scanner.scanLicensePlate(on: image)
}

