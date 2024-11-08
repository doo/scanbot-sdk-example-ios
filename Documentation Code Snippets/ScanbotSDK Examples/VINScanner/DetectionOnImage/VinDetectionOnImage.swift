//
//  VinDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import Foundation
import ScanbotSDK
    
func detectVinOnImage() {
    
    // Image containing Vehicle identification number.
    guard let image = UIImage(named: "vinImage") else { return }
    
    // Creates an instance of `SBSDKVehicleIdentificationNumberScanner` using the default configuration.
    
    let scanner = SBSDKGenericTextLineScanner(configuration: .vehicleIdentificationNumber())
    
    // Returns the result after running detector on the image.
    let result = scanner.scanTextLine(on: image)
}
