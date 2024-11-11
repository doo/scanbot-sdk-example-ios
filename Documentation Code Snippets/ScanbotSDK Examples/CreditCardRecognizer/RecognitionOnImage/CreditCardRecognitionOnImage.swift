//
//  CreditCardDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 11.11.24.
//

import Foundation
import ScanbotSDK

func recognizeCreditCardOnImage() {
    
    // Image containing Check.
    guard let image = UIImage(named: "creditCardImage") else { return }
    
    // Create the default SBSDKCreditCardRecognizerConfiguration object
    let configuration = SBSDKCreditCardRecognizerConfiguration()
    
    // Set the recognition mode to single shot.
    configuration.recognitionMode = .singleShot
    
    // Creates an instance of `SBSDKCreditCardRecognizer`.
    let recognizer = SBSDKCreditCardRecognizer(configuration: configuration)
    
    // Returns the result after running the recognizer on the image.
    let result = recognizer.recognizeCreditCard(on: image)
}
