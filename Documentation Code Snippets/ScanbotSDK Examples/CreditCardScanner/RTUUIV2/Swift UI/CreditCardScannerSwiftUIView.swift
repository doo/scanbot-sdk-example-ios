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
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if scannedCreditCard == nil && scanError == nil {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2CreditCardScannerView(configuration: configuration) { result, error in
                
                scannedCreditCard = result
                scanError = error
            }
            .ignoresSafeArea()
            
        } else if let scannedCreditCard {
            
            // Process and show the scanned credit card here.
            
            // Cast the resulted generic document to the credit card model using the `wrap` method.
            if let model = scannedCreditCard.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {
                
                // Retrieve the values.
                // e.g
                if let cardNumber = model.cardNumber?.value {
                    Text("Card number: \(cardNumber.text), Confidence: \(cardNumber.confidence)")
                }
                if let name = model.cardholderName?.value {
                    Text("Name: \(name.text), Confidence: \(name.confidence)")
                }
            }
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
        }
    }
}

#Preview {
    CreditCardScannerSwiftUIView()
}
