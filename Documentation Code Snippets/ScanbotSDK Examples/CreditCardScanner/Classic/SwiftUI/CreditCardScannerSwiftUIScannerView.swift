//
//  CreditCardScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `CreditCardScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct CreditCardScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKCreditCardScannerViewController`.
    @State private var viewModel: SBSDKCreditCardScannerViewModel = {

        // Create the default `SBSDKCreditCardScannerConfiguration` object.
        let configuration = SBSDKCreditCardScannerConfiguration()

        // Disable the requiring of the expiration date.
        configuration.requireExpiryDate = false

        // Disable the requiring of the card holder name.
        configuration.requireCardholderName = false

        // Enable the credit card image extraction.
        configuration.returnCreditCardImage = true

        return try! SBSDKCreditCardScannerViewModel(scannerConfiguration: configuration)
    }()

    var body: some View {

        // Embed the `SBSDKCreditCardScannerViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKCreditCardScannerViewControllerDelegate`.
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .failure(let error):
                    // Handle the error.
                    print("Error scanning credit card: \(error.localizedDescription)")

                case .validResult(let result, _):
                    // Access the document's fields directly by iterating over the document's fields.
                    result.creditCard?.fields.forEach { field in
                        // Print field type name, field text and field confidence to the console.
                        print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
                    }

                    // Get the cropped image.
                    let croppedImage = try? result.creditCard?.crop?.toUIImage()

                    // Or create a wrapper for the document if needed to access the fields more easily.
                    // You must cast it to the specific document model wrapper subclass.
                    if let wrapper = result.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {

                        // Now you can access the document's fields easily through the wrapper.

                        if let creditCardNumber = wrapper.cardNumber {
                            print("Credit card number: \(creditCardNumber.value?.text ?? "")")
                        }

                        if let cardHolderName = wrapper.cardholderName {
                            print("Cardholder name: \(cardHolderName.value?.text ?? "")")
                        }

                        if let expiryDate = wrapper.expiryDate {
                            print("Expiration date: \(expiryDate.value?.text ?? "")")
                        }
                    }

                case .everyFrame:
                    // Fired for every processed frame, regardless of validity; nothing to do here.
                    break
                }
            }
    }
}

#Preview {
    CreditCardScannerSwiftUIScannerView()
}
