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
    
    var body: some View {
        
        // Show the scanner, passing the configuration and handling the result.
        SBSDKUI2CheckScannerView(configuration: configuration) { result in
            
            if let result {
                scannedCheck = result
                
                // Cast the resulted generic document to the appropriate check model using the `wrap` method.
                if let genericDocument = result.check, let wrapper = genericDocument.wrap() {
                    // Select the appropriate check type based on the wrapper instance
                    if let usaCheck = wrapper as? SBSDKCheckDocumentModelUSACheck {
                        // Retrieve values from the USA Check
                        if let accountNumber = usaCheck.accountNumber?.value {
                            print("Account number: \(accountNumber.text), Confidence: \(accountNumber.confidence)")
                        }
                        if let transitNumber = usaCheck.transitNumber?.value {
                            print("Transit number: \(transitNumber.text), Confidence: \(transitNumber.confidence)")
                        }
                        if let auxiliaryOnUs = usaCheck.auxiliaryOnUs?.value {
                            print("Auxiliary On-Us: \(auxiliaryOnUs.text), Confidence: \(auxiliaryOnUs.confidence)")
                        }
                    } else if let unknownCheck = wrapper as? SBSDKCheckDocumentModelUnknownCheck {
                        // Handle unknown check format
                        print("Unknown check format detected")
                        // Access available fields from the unknown check format
                        if let fields = genericDocument.allFields(includeEmptyFields: false) {
                            for field in fields {
                                if let value = field.value {
                                    print("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                                }
                            }
                        }
                    }
                    // Other check types can be added as needed (AUS, FRA, IND, ISR, KWT, etc.)
                }
                
            } else {
                
                // Dismiss your view here.
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CheckScannerSwiftUIView()
}
