//
//  TextPatternLocalizationUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TextPatternLocalizationUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()

        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization

        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
        return configuration
    }()
    
    @State private var scanError: Error?

    var body: some View {
        
        if let scanError {

            if (scanError as? SBSDKError)?.isCanceled == true {
                Text("The operation was cancelled before completion or by the user")
            } else {
                Text("Error scanning Text Pattern: \(scanError.localizedDescription)")
            }

        } else {
            SBSDKUI2TextPatternScannerView(configuration: configuration, completion: { result, error in
            
            // Handle the result.
            if let result {
                
                print(result.rawText)
                print(result.confidence)
                result.wordBoxes.forEach { wordBox in
                    print(wordBox.text)
                    print(wordBox.recognitionConfidence)
                    print(wordBox.boundingRect)
                }
                result.symbolBoxes.forEach { symbolBox in
                    print(symbolBox.symbol)
                    print(symbolBox.recognitionConfidence)
                    print(symbolBox.boundingRect)
                }
            }
            
            if let error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    // Any other error
                    print("Error scanning Text Pattern: \(error.localizedDescription)")
                }
                scanError = error
            }
        })
                .ignoresSafeArea()
        }
    }
}

#Preview {
    TextPatternLocalizationUI2SwiftUIView()
}
