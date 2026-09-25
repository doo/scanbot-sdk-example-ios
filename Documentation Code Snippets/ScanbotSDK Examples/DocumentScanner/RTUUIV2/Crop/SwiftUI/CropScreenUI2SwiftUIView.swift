//
//  CropScreenUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CropScreenUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Retrieve the instance of the crop configuration from the main configuration object.
        let cropScreenConfiguration = configuration.screens.cropping

        // For example disable the rotation feature...
        cropScreenConfiguration.toolbar.rotateButton.visible = false

        // ... configure various colors...
        configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(colorString: "#C8193C")
        cropScreenConfiguration.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)

        // ... customize a UI element's text.
        configuration.localization.croppingTopBarCancelButtonTitle = "Cancel"

        return configuration
    }()

    @State private var scannedDocument: SBSDKScannedDocument?
    @State private var scanError: Error?
    
    var body: some View {
        
        if let scannedDocument {
            
            // Process and show the resulting document here.
            Text("Document scanned with \(scannedDocument.pages.count) pages")
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
            
        } else {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2DocumentScannerView(configuration: configuration,
                                                                  completion: { result, error in
                if let result {
                    scannedDocument = result
                }

                if let error {
                    if case SBSDKError.operationCanceled = error {
                        print("The operation was cancelled before completion or by the user")
                    } else {
                        // Any other error
                        print("Error scanning document: \(error.localizedDescription)")
                    }

                    scanError = error
                }
            })
                    .ignoresSafeArea()

        }
    }
}

#Preview {
    CropScreenUI2SwiftUIView()
}
