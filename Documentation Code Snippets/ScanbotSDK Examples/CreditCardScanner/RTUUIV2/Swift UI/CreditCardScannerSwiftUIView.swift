//
//  CreditCardScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import SwiftUI
import ScanbotSDK

struct CreditCardScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2CreditCardScannerScreenConfiguration` which contains the configuration settings
    // for the credit card scanner.
    let configuration: SBSDKUI2CreditCardScannerScreenConfiguration = {
        
        return SBSDKUI2CreditCardScannerScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2CreditCardScannerUIResult` object containing the resulted credit card of the scanning process.
    @State var scannedCreditCard: SBSDKUI2CreditCardScannerUIResult?
    
    var body: some View {
        
        // Show the scanner, passing the configuration and handling the result.
        SBSDKUI2CreditCardScannerView(configuration: configuration) { result in
            
            if let result {
                scannedCreditCard = result
                
                // Cast the resulted generic document to the credit card model using the `wrap` method.
                if let model = result.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {
                    
                    // Retrieve the values.
                    // e.g
                    if let cardNumber = model.cardNumber?.value {
                        print("Card number: \(cardNumber.text), Confidence: \(cardNumber.confidence)")
                    }
                    if let name = model.cardholderName?.value {
                        print("Name: \(name.text), Confidence: \(name.confidence)")
                    }
                }
                
            } else {
                
                // Dismiss your view here.
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CreditCardScannerSwiftUIView()
}
