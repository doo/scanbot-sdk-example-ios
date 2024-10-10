//
//  MRZDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func detectMRZOnImage() {
    
    // Image containing MRZ.
    guard let image = UIImage(named: "mrzImage") else { return }
    
    // Creates an instance of `SBSDKMachineReadableZoneRecognizer`.
    let detector = SBSDKMachineReadableZoneRecognizer()
    
    // Returns the result after running detector on the image.
    let result = detector.recognizePersonalIdentity(from: image)
}
