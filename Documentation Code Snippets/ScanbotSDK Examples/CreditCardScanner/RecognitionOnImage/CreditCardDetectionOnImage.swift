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
    
    // Create the default configuration object.
    let configuration = SBSDKCreditCardScannerConfiguration()
    
    // Enable the credit card image extraction.
    configuration.returnCreditCardImage = true
    
    do {
        
        // Create an instance of credit card scanner.
        let scanner = try SBSDKCreditCardScanner(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run credit card scanner on the image.
        let result = try scanner.run(image: imageRef)
        
        // Get the cropped image.
        let croppedImage = try result.creditCard?.crop?.toUIImage()
    }
    catch {
        print("Error scanning credit card: \(error.localizedDescription)")
    }
}
