//
//  VINLocalizationUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct VINLocalizationUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2VINScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()

        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization

        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")

        
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
    VINLocalizationUI2SwiftUIView()
}
