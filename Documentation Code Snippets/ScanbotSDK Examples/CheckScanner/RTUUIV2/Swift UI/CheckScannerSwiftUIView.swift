//
//  CheckScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import SwiftUI
import ScanbotSDK

struct CheckScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2CheckScannerScreenConfiguration` which contains the configuration settings
    // for the check scanner.
    let configuration: SBSDKUI2CheckScannerScreenConfiguration = {
        
        return SBSDKUI2CheckScannerScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2CheckScannerUIResult` object containing the resulted check of the scanning process.
    @State var scannedCheck: SBSDKUI2CheckScannerUIResult?
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if scannedCheck == nil && scanError == nil {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2CheckScannerView(configuration: configuration) { result, error in
                
                scannedCheck = result
                scanError = error
            }
            .ignoresSafeArea()
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
            
        } else if let scannedCheck {
            
            // Process and show the scanned check here.
            
            // Cast the resulted generic document to the appropriate check model using the `wrap` method.
            if let genericDocument = scannedCheck.check, let wrapper = genericDocument.wrap() {
                
                // Select the appropriate check type based on the wrapper instance
                if let usaCheck = wrapper as? SBSDKCheckDocumentModelUSACheck {
                    
                    // Retrieve values from the USA Check
                    VStack(alignment: .leading) {
                        if let accountNumber = usaCheck.accountNumber?.value {
                            Text("Account number: \(accountNumber.text), Confidence: \(accountNumber.confidence)")
                        }
                        if let transitNumber = usaCheck.transitNumber?.value {
                            Text("Transit number: \(transitNumber.text), Confidence: \(transitNumber.confidence)")
                        }
                        if let auxiliaryOnUs = usaCheck.auxiliaryOnUs?.value {
                            Text("Auxiliary On-Us: \(auxiliaryOnUs.text), Confidence: \(auxiliaryOnUs.confidence)")
                        }
                    }
                } else if wrapper is SBSDKCheckDocumentModelUnknownCheck {
                    
                    // Handle unknown check format
                    VStack(alignment: .leading) {
                        Text("Unknown check format detected")
                        
                        // Access available fields from the unknown check format
                        if let fields = genericDocument.allFields(includeEmptyFields: false) {
                            ForEach(fields, id: \.type.name) { field in
                                if let value = field.value {
                                    Text("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                                }
                            }
                        }
                    }
                }
                // Other check types can be added as needed (AUS, FRA, IND, ISR, KWT, etc.)
            } else {
                Text("No document found.")
            }
        }
    }
}

#Preview {
    CheckScannerSwiftUIView()
}
