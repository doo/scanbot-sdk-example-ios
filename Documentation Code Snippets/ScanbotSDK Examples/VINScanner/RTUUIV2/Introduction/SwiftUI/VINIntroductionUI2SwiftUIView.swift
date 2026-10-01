//
//  VINIntroductionUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct VINIntroductionUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2VINScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()

        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true

        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan VIN"

        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .vinIntroNoImage()
        // For a custom image...
        configuration.introScreen.image = .vinIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default images.
        // e.g the meter device image.
        configuration.introScreen.image = .vinIntroDefaultImage()
                
        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // Configure the text.
        configuration.introScreen.explanation.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.explanation.text = "To scan a VIN (Vehicle Identification Number), please hold your device so that the camera viewfinder clearly captures the VIN code. Please ensure the VIN is properly aligned. Once the scan is complete, the VIN will be automatically extracted.\n\nPress 'Start Scanning' to begin."

        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")

        
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
    VINIntroductionUI2SwiftUIView()
}
