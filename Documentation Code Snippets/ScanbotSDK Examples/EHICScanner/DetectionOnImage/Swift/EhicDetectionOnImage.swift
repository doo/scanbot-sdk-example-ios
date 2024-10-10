//
//  EhicDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK
    
func detectEhicOnImage() {
    
    // Image containing EU Health Insurance Card.
    guard let image = UIImage(named: "ehicImage") else { return }
    
    // Creates an instance of `SBSDKHealthInsuranceCardRecognizer`.
    let detector = SBSDKHealthInsuranceCardRecognizer()
    
    // Returns the result after running detector on the image.
    let result = detector.recognize(onStillImage: image)
}
