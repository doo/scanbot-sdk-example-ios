//
//  DocumentDataExtractorSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import SwiftUI
import ScanbotSDK

struct DocumentDataExtractorSwiftUIView: View {
    
    // An instance of `SBSDKUI2DocumentDataExtractorScreenConfiguration` which contains the configuration settings
    // for the document data extractor.
    let configuration: SBSDKUI2DocumentDataExtractorScreenConfiguration = {
        
        return SBSDKUI2DocumentDataExtractorScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2DocumentDataExtractorUIResult` object containing the resulted document of the scanning process.
    @State var scannedDocument: SBSDKUI2DocumentDataExtractorUIResult?
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if scannedDocument == nil, scanError == nil {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2DocumentDataExtractorView(configuration: configuration) { result, error in
                
                scannedDocument = result
                scanError = error
            }
            .ignoresSafeArea()
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
            
        } else if let scannedDocument {
            
            // Process and show the scanned document here.
            
            // Cast the resulted generic document to the appropriate document model using the `wrap` method.
            if let genericDocument = scannedDocument.document, let wrapper = genericDocument.wrap() {
                
                // Use SBSDKDocumentsModelDeIdCardFront for German ID card front
                if let idCardFront = wrapper as? SBSDKDocumentsModelDeIdCardFront {
                    VStack(alignment: .leading, spacing: 8) {
                        if let birthDate = idCardFront.birthDate?.value {
                            Text("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                        }
                        if let birthplace = idCardFront.birthplace?.value {
                            Text("Birthplace: \(birthplace.text), Confidence: \(birthplace.confidence)")
                        }
                        if let cardAccessNumber = idCardFront.cardAccessNumber?.value {
                            Text("Card access number: \(cardAccessNumber.text), Confidence: \(cardAccessNumber.confidence)")
                        }
                        if let expiryDate = idCardFront.expiryDate?.value {
                            Text("Expiry date: \(expiryDate.text), Confidence: \(expiryDate.confidence)")
                        }
                        if let givenNames = idCardFront.givenNames?.value {
                            Text("Given names: \(givenNames.text), Confidence: \(givenNames.confidence)")
                        }
                        if let id = idCardFront.id?.value {
                            Text("ID: \(id.text), Confidence: \(id.confidence)")
                        }
                        if let maidenName = idCardFront.maidenName?.value {
                            Text("Maiden name: \(maidenName.text), Confidence: \(maidenName.confidence)")
                        }
                        if let nationality = idCardFront.nationality?.value {
                            Text("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                        }
                        if let surname = idCardFront.surname?.value {
                            Text("Surname: \(surname.text), Confidence: \(surname.confidence)")
                        }
                        if let series = idCardFront.series?.value {
                            Text("Series: \(series.text), Confidence: \(series.confidence)")
                        }
                        // Note: photo and signature are image fields and might need special handling
                    }
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Document detected, but not a German ID card front")
                        if let fields = genericDocument.allFields(includeEmptyFields: false) {
                            ForEach(Array(fields.enumerated()), id: \.offset) { _, field in
                                if let value = field.value {
                                    Text("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                                }
                            }
                        }
                    }
                }
                // Other document types can be added as needed (passport, driver license, etc.)
            }
        }
    }
}

#Preview {
    DocumentDataExtractorSwiftUIView()
}
