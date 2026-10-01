//
//  MRZActionBarUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct MRZActionBarUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2MRZScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()

        // Retrieve the instance of the action bar from the configuration object.
        let actionBar = configuration.actionBar

        // Show the flash button.
        actionBar.flashButton.visible = true

        // Configure the inactive state of the flash button.
        actionBar.flashButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flashButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the active state of the flash button.
        actionBar.flashButton.activeBackgroundColor = SBSDKUI2Color(colorString: "#FFCE5C")
        actionBar.flashButton.activeForegroundColor = SBSDKUI2Color(colorString: "#000000")

        // Show the zoom button.
        actionBar.zoomButton.visible = true

        // Configure the zoom button.
        actionBar.zoomButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.zoomButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Show the flip camera button.
        actionBar.flipCameraButton.visible = true

        // Configure the flip camera button.
        actionBar.flipCameraButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flipCameraButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        
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
    MRZActionBarUI2SwiftUIView()
}
