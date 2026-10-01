//
//  CheckPaletteUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CheckPaletteUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CheckScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()

        // Retrieve the instance of the palette from the configuration object.
        let palette = configuration.palette

        // Configure the colors.
        // The palette already has the default colors set, so you don't have to always set all the colors.
        palette.sbColorPrimary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorPrimaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorNegative = SBSDKUI2Color(colorString: "#FF3737")
        palette.sbColorPositive = SBSDKUI2Color(colorString: "#4EFFB4")
        palette.sbColorWarning = SBSDKUI2Color(colorString: "#FFCE5C")
        palette.sbColorSecondary = SBSDKUI2Color(colorString: "#FFEDEE")
        palette.sbColorSecondaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorOnPrimary = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOnSecondary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorSurface = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOutline = SBSDKUI2Color(colorString: "#EFEFEF")
        palette.sbColorOnSurfaceVariant = SBSDKUI2Color(colorString: "#707070")
        palette.sbColorOnSurface = SBSDKUI2Color(colorString: "#000000")
        palette.sbColorSurfaceLow = SBSDKUI2Color(colorString: "#26000000")
        palette.sbColorSurfaceHigh = SBSDKUI2Color(colorString: "#7A000000")
        palette.sbColorModalOverlay = SBSDKUI2Color(colorString: "#A3000000")

        
        return configuration
    }()
    
    @State private var result: SBSDKUI2CheckScannerUIResult?
    @State private var scanError: Error?
    
    var body: some View {
        
        if result == nil && scanError == nil {
            
            // Create and present the scanner view.
            SBSDKUI2CheckScannerView(configuration: configuration, completion: { result, error in
                
                if let result {

                    // Handle the result.

                    // Cast the resulting generic document to the appropriate check model using the `wrap` method.
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
                            // Other check types can be added as needed (AUS, FRA, IND, ISR, KWT, etc.)
                        }
                    }
                            
                }
                
                self.result = result
                self.scanError = error
            })
                    .ignoresSafeArea()

            
        } else if let scanError {
            
            switch scanError {
            case SBSDKError.operationCanceled:
                Text("The operation was cancelled before completion or by the user")
            default:
                // Any other error
                Text("Error scanning check: \(scanError.localizedDescription)")
            }
            
        } else {
            EmptyView()
        }
    }
}

#Preview {
    CheckPaletteUI2SwiftUIView()
}
