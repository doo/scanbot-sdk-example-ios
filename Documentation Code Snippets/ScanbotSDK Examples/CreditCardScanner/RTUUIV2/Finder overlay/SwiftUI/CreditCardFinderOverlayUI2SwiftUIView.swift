//
//  CreditCardFinderOverlayUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CreditCardFinderOverlayUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CreditCardScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()

        // Set the example overlay visibility.
        configuration.exampleOverlayVisible = true

        // Configure the view finder.
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
        return configuration
    }()
    
    @State private var scanError: Error?

    var body: some View {
        if let scanError {
            Text("Scan error: \(scanError.localizedDescription)")
        } else {

        
        // Create and present the scanner view.
        SBSDKUI2CreditCardScannerView(configuration: configuration, completion: { result, error in
            
            // Handle the result.
            if let result {
                
                // Cast the resulting generic document to the credit card model using the `wrap` method.
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
            }
            
            if let error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    // Any other error
                    print("Error scanning credit card: \(error.localizedDescription)")

                    scanError = error
                }
            }
        })
                .ignoresSafeArea()

            }
}
}

#Preview {
    CreditCardFinderOverlayUI2SwiftUIView()
}
