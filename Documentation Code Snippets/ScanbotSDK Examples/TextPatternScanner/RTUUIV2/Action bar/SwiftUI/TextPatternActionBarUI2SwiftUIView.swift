//
//  TextPatternActionBarUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TextPatternActionBarUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()

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
    TextPatternActionBarUI2SwiftUIView()
}
