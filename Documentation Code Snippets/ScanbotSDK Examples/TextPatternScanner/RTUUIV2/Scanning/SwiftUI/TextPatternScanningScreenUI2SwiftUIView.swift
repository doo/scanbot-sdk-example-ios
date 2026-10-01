//
//  TextPatternScanningScreenUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TextPatternScanningScreenUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()

        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 5.0]
        configuration.cameraConfiguration.flashEnabled = false
        configuration.cameraConfiguration.pinchToZoomEnabled = true

        // Configure the UI elements like icons or buttons.
        // e.g The top bar introduction button.
        configuration.topBarOpenIntroScreenButton.visible = true
        configuration.topBarOpenIntroScreenButton.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Cancel button.
        configuration.topBar.cancelButton.visible = true
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.topBar.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")

        // Configure the view finder.
        // Set the desired aspect ratio.
        configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 3.85, height: 1.0)
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 2.0)

        // Configure the success overlay.
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep

        // Configure the vibration.
        configuration.vibration.enabled = false
        
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
    TextPatternScanningScreenUI2SwiftUIView()
}
