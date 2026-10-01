//
//  MRZUserGuidanceUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct MRZUserGuidanceUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2MRZScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()

        // Configure user guidances

        // Top user guidance
        // Retrieve the instance of the top user guidance from the configuration object.
        let topUserGuidance = configuration.topUserGuidance
        // Show the user guidance.
        topUserGuidance.visible = true
        // Configure the title.
        topUserGuidance.title.text = "Scan your Identity Document"
        topUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")

        // Finder overlay user guidance
        // Retrieve the instance of the finder overlay user guidance from the configuration object.
        let finderUserGuidance = configuration.finderViewUserGuidance
        // Show the user guidance.
        finderUserGuidance.visible = true
        // Configure the title.
        finderUserGuidance.title.text = "Scan the MRZ"
        finderUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        finderUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")

        
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
    MRZUserGuidanceUI2SwiftUIView()
}
