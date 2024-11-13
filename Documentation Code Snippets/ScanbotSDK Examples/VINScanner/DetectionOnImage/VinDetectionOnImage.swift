//
//  VinDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import Foundation
import ScanbotSDK
    
func scanVinOnImage() {
    
    // The image containing a vehicle identification number.
    guard let image = UIImage(named: "vinImage") else { return }
    
    // Create an instance of the configuration for vehicle identification numbers.
    let configuration = SBSDKGenericTextLineScannerConfiguration.vehicleIdentificationNumber()
    
    // Create an instance of `SBSDKGenericTextLineScanner` using the configuration created above.
    let scanner = SBSDKGenericTextLineScanner(configuration: configuration)
    
    // Run the scanner on the image.
    let result = scanner.scanTextLine(on: image)
}
