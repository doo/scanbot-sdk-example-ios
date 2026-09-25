//
//  TextPatternTopBarUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TextPatternTopBarUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()

        // Set the top bar mode.
        configuration.topBar.mode = .gradient

        // Set the background color which will be used as a gradient.
        configuration.topBar.backgroundColor = SBSDKUI2Color(colorString: "#C8193C")

        // Set the status bar mode.
        configuration.topBar.statusBarMode = .light

        // Configure the cancel button.
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
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
    TextPatternTopBarUI2SwiftUIView()
}
