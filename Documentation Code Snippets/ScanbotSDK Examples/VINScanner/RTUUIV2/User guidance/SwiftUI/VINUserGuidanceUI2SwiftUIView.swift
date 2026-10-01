//
//  VINUserGuidanceUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct VINUserGuidanceUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2VINScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()

        // Configure user guidances

        // Top user guidance
        // Retrieve the instance of the top user guidance from the configuration object.
        let topUserGuidance = configuration.topUserGuidance
        // Show the user guidance.
        topUserGuidance.visible = true
        // Configure the title.
        topUserGuidance.title.text = "Locate the VIN you are looking for"
        topUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")

        // Finder overlay user guidance
        // Retrieve the instance of the finder overlay user guidance from the configuration object.
        let finderUserGuidance = configuration.finderViewUserGuidance
        // Show the user guidance.
        finderUserGuidance.visible = true
        // Configure the title.
        finderUserGuidance.title.text = "Scanning for VIN..."
        finderUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        finderUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")

        
        return configuration
    }()
    
    @State private var result: SBSDKUI2VINScannerUIResult?
    @State private var scanError: Error?
    
    var body: some View {
        
        if result == nil && scanError == nil {
            
            // Create and present the scanner view.
            SBSDKUI2VINScannerView(configuration: configuration, completion: { result, error in
                
                if let result {

                    // Handle the result.
                    print(result.textResult.rawText)
                    print(result.textResult.confidence)
                    print(result.textResult.validationSuccessful)

                    // If expecting VIN from barcode.
                    print(result.barcodeResult.extractedVIN)
                    print(result.barcodeResult.status)
                    print(result.barcodeResult.rectangle)
                            
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
                Text("Error scanning VIN: \(scanError.localizedDescription)")
            }
            
        } else {
            EmptyView()
        }
    }
}

#Preview {
    VINUserGuidanceUI2SwiftUIView()
}
