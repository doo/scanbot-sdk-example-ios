//
//  CreditCardActionBarUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CreditCardActionBarUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CreditCardScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()

        // Retrieve the instance of the action bar from the configuration object.
        let actionBar = configuration.actionBar

        // Show the flash button.
        actionBar.flashButton.visible = true

        // Configure the inactive state of the flash button.
        actionBar.flashButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flashButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the active state of the flash button.
        actionBar.flashButton.activeBackgroundColor = SBSDKUI2Color(colorString: "#FFCE5C")
        actionBar.flashButton.activeForegroundColor = SBSDKUI2Color(colorString: "#000000")

        // Show the zoom button.
        actionBar.zoomButton.visible = true

        // Configure the zoom button.
        actionBar.zoomButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.zoomButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Show the flip camera button.
        actionBar.flipCameraButton.visible = true

        // Configure the flip camera button.
        actionBar.flipCameraButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flipCameraButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
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
    CreditCardActionBarUI2SwiftUIView()
}
