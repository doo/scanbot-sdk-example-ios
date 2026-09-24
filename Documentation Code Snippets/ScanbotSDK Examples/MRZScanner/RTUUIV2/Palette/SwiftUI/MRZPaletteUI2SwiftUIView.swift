//
//  MRZPaletteUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct MRZPaletteUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2MRZScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()

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
    
    @State private var result: SBSDKUI2MRZScannerUIResult?
    @State private var scanError: Error?
    
    var body: some View {
        
        if result == nil && scanError == nil {
            
            // Create and present the scanner view.
            SBSDKUI2MRZScannerView(configuration: configuration, completion: { result, error in
                
                if let result {

                    // Handle the result.

                    // Cast the resulting generic document to the MRZ model using the `wrap` method.
                    if let model = result.mrzDocument?.wrap() as? SBSDKDocumentsModelMRZ {
                        
                        // Retrieve the values.
                        // e.g
                        if let birthDate = model.birthDate?.value {
                            print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                        }
                        if let nationality = model.nationality?.value {
                            print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
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
                Text("Error scanning MRZ: \(scanError.localizedDescription)")
            }
            
        } else {
            EmptyView()
        }
    }
}

#Preview {
    MRZPaletteUI2SwiftUIView()
}
