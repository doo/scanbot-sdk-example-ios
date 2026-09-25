//
//  DocumentDataExtractorFinderOverlayUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentDataExtractorFinderOverlayUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentDataExtractorScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()

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
        SBSDKUI2DocumentDataExtractorView(configuration: configuration, completion: { result, error in
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
    DocumentDataExtractorFinderOverlayUI2SwiftUIView()
}
