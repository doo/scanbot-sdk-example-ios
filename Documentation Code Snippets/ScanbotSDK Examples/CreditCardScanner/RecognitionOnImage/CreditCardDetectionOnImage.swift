//
//  CreditCardDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 11.11.24.
//

import Foundation
import ScanbotSDK

func scanCreditCardFromImage() {
    
    // An image containing a credit card.
    guard let image = UIImage(named: "creditCardImage") else { return }
    
    // Create the default `SBSDKCreditCardScannerConfiguration` object.
    let configuration = SBSDKCreditCardScannerConfiguration()
    
    // Set the scanning mode to single shot.
    configuration.scanningMode = .singleShot
    
    // Enable the credit card image extraction.
    configuration.returnCreditCardImage = true
    
    // Create an instance of `SBSDKCreditCardScanner`.
    let scanner = SBSDKCreditCardScanner(configuration: configuration)
    
    // Returns the result after running the scanner on the image.
    let result = scanner.scan(from: image)
    
    // Get the cropped image.
    let croppedImage = result?.creditCard?.crop?.toUIImage()
    
}
