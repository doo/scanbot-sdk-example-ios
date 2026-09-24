//
//  CreditCardIntroductionUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CreditCardIntroductionUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CreditCardScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()

        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true

        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan a credit card"

        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .creditCardNoImage()
        // For a custom image...
        configuration.introScreen.image = .creditCardIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default one sided image.
        configuration.introScreen.image = .creditCardIntroOneSideImage()
        // Or you can also use our default two sided image.
        configuration.introScreen.image = .creditCardIntroTwoSidesImage()

        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the text.
        configuration.introScreen.explanation.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.explanation.text = "To quickly and securely input your credit card details, please hold your device over the credit card, so that the camera aligns with the numbers on the front of the card.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your card details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin."

        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
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
    CreditCardIntroductionUI2SwiftUIView()
}
