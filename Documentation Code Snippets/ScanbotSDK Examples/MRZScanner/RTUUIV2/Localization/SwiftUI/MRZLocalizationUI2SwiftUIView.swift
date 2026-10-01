//
//  MRZLocalizationUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct MRZLocalizationUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2MRZScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()

        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization

        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")

        
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
    MRZLocalizationUI2SwiftUIView()
}
