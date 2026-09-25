//
//  CreditCardScanningUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CreditCardScanningUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CreditCardScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()

        // Configure the timeout for the scan process. If the scan process takes longer than this value, the
        // incomplete result will be returned.
        configuration.scanIncompleteDataTimeout = 500

        // Configure the success overlay.
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Set the timeout after which the overlay is dismissed.
        configuration.successOverlay.timeout = 100

        // Configure the incomplete scan overlay.
        configuration.incompleteDataOverlay.message.text = "Incomplete scan"
        configuration.incompleteDataOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.incompleteDataOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Set the timeout after which the overlay is dismissed.
        configuration.incompleteDataOverlay.timeout = 100

        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 3.0]
        configuration.cameraConfiguration.flashEnabled = false
        configuration.cameraConfiguration.pinchToZoomEnabled = true

        // Configure the UI elements like icons or buttons.
        // e.g The top bar introduction button.
        configuration.topBarOpenIntroScreenButton.visible = true
        configuration.topBarOpenIntroScreenButton.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Cancel button.
        configuration.topBar.cancelButton.visible = true
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.topBar.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")

        // Configure the view finder.
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)

        // Configure the action bar.
        configuration.actionBar.flashButton.visible = true
        configuration.actionBar.zoomButton.visible = true
        configuration.actionBar.flipCameraButton.visible = false

        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep

        // Configure the vibration.
        configuration.vibration.enabled = false
        
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
    CreditCardScanningUI2SwiftUIView()
}
