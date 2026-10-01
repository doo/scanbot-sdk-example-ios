//
//  DocumentDataExtractorIntroductionUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentDataExtractorIntroductionUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentDataExtractorScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()

        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true

        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan a document"

        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .documentDataIntroNoImage()
        // For a custom image...
        configuration.introScreen.image = .documentDataIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default image.
        configuration.introScreen.image = .documentDataIntroDefaultImage()

        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the text.
        configuration.introScreen.explanation.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.explanation.text = "To quickly and securely scan your document details, please hold your device over the document, so that the camera aligns with all the information on the document.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your document details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin."

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
        SBSDKUI2DocumentDataExtractorView(configuration: configuration, completion: { result, error in
            
            // Handle the result.
            if let result {
                
                // Cast the resulting generic document to the appropriate document model using the `wrap` method.
                if let genericDocument = result.document, let wrapper = genericDocument.wrap() {
                    // Use SBSDKDocumentsModelDeIdCardFront for German ID card front side
                    if let idCardFront = wrapper as? SBSDKDocumentsModelDeIdCardFront {
                        // Retrieve values from the German ID card front
                        if let birthDate = idCardFront.birthDate?.value {
                            print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                        }
                        if let birthplace = idCardFront.birthplace?.value {
                            print("Birthplace: \(birthplace.text), Confidence: \(birthplace.confidence)")
                        }
                        if let cardAccessNumber = idCardFront.cardAccessNumber?.value {
                            print("Card access number: \(cardAccessNumber.text), Confidence: \(cardAccessNumber.confidence)")
                        }
                        if let expiryDate = idCardFront.expiryDate?.value {
                            print("Expiry date: \(expiryDate.text), Confidence: \(expiryDate.confidence)")
                        }
                        if let givenNames = idCardFront.givenNames?.value {
                            print("Given names: \(givenNames.text), Confidence: \(givenNames.confidence)")
                        }
                        if let id = idCardFront.id?.value {
                            print("ID: \(id.text), Confidence: \(id.confidence)")
                        }
                        if let maidenName = idCardFront.maidenName?.value {
                            print("Maiden name: \(maidenName.text), Confidence: \(maidenName.confidence)")
                        }
                        if let nationality = idCardFront.nationality?.value {
                            print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                        }
                        if let surname = idCardFront.surname?.value {
                            print("Surname: \(surname.text), Confidence: \(surname.confidence)")
                        }
                        if let series = idCardFront.series?.value {
                            print("Series: \(series.text), Confidence: \(series.confidence)")
                        }
                        // Note: photo and signature are image fields and might need special handling
                    } else {
                        // Handle other document types
                        print("Document detected, but not a German ID card front")
                        // Access available fields from the document
                        if let fields = genericDocument.allFields(includeEmptyFields: false) {
                            for field in fields {
                                if let value = field.value {
                                    print("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                                }
                            }
                        }
                        // Other document types can be added as needed (passport, driver license, etc.)
                    }
                }
            }
            
            if let error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    // Any other error
                    print("Error extracting document data: \(error.localizedDescription)")

                    scanError = error
                }
            }
        })
                .ignoresSafeArea()

            }
}
}

#Preview {
    DocumentDataExtractorIntroductionUI2SwiftUIView()
}
