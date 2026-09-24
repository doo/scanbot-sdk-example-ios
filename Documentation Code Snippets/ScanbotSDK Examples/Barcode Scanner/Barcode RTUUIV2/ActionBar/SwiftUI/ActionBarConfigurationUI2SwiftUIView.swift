//
//  ActionBarConfigurationUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ActionBarConfigurationUI2SwiftUIView: View {
    
    @State private var configuration = Self.makeConfiguration()
    @State private var scanError: Error?
    @State private var scannerResult: SBSDKUI2BarcodeScannerUIResult?
    
    var body: some View {
        
        if let scannerResult {
            Text("Barcodes scanned: \(scannerResult.items.count)")

        } else if let scanError {
            Text("Scan error: \(scanError.localizedDescription)")

        } else {
            
            // Create and present the scanner view.
            SBSDKUI2BarcodeScannerView(configuration: configuration,
                                                                 completion: { result, error in
                scannerResult = result
                scanError = error
                if let result {
                    handle(result: result)
                }
                if let error {
                    if case SBSDKError.operationCanceled = error {
                        print("The operation was cancelled before completion or by the user")
                    } else {
                        // Any other error
                        print("Error scanning barcode: \(error.localizedDescription)")
                    }
                }
            })
                    .ignoresSafeArea()

        }
    }
    
    static func makeConfiguration() -> SBSDKUI2BarcodeScannerScreenConfiguration {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()

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

        // Create and set an array of accepted barcode formats.
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        return configuration
    }
    
    func handle(result: SBSDKUI2BarcodeScannerUIResult) {
        
        // Handle the result.
        result.items.forEach { barcodeItem in
            // e.g
            print(barcodeItem.count)
            print(barcodeItem.barcode.format.name)
            print(barcodeItem.barcode.text)
            print(barcodeItem.barcode.textWithExtension)
            // Check out other available properties in `SBSDKBarcodeItem`.
        }
        print(result.selectedZoomFactor)
    }
}

#Preview {
    ActionBarConfigurationUI2SwiftUIView()
}
