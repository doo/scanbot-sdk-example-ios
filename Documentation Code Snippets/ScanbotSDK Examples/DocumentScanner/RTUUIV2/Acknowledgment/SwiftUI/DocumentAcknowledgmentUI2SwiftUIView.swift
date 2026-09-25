//
//  DocumentAcknowledgmentUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentAcknowledgmentUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Set the acknowledgment mode.
        // Modes:
        // - `always`: Runs the quality analyzer on the captured document and always displays the acknowledgment screen.
        // - `badQuality`: Runs the quality analyzer and displays the acknowledgment screen only if the quality is poor.
        // - `none`: Skips the quality check entirely.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always

        // Set the minimum threshold of unacceptable and uncertain qualities.
        configuration.screens.camera.documentQualityAnalyzerConfiguration.qualityUnacceptableUncertainThreshold  = 0.75

        // Set the background color for the acknowledgment screen.
        configuration.screens.camera.acknowledgement.backgroundColor = SBSDKUI2Color(colorString: "#EFEFEF")

        // You can also configure the buttons in the bottom bar of the acknowledgment screen.
        // E.g. to force the user to retake, if the captured document is not acceptable.
        configuration.screens.camera.acknowledgement.toolbar.acceptWhenAcceptableButton.visible = false

        // Hide the titles of the buttons.
        configuration.screens.camera.acknowledgement.toolbar.acceptWhenAcceptableButton.title.visible = false
        configuration.screens.camera.acknowledgement.toolbar.acceptWhenAcceptableButton.title.visible = false
        configuration.screens.camera.acknowledgement.toolbar.retakeButton.title.visible = false

        // Configure the acknowledgment screen's hint message which is shown if the least acceptable quality is not met.
        configuration.screens.camera.acknowledgement.unacceptableQualityWarning.visible = true

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
                    
                    // Handle the result.
                    print(result.uuid)
                    print(result.pageCount)
                    print(result.documentImageSizeLimit)
                    print(result.pdfURI)
                    print(result.tiffURI)
                    print(result.creationDate)

                    // Check out other available properties in `SBSDKScannedDocument`.

                    result.pages.forEach { scannedPage in
                        
                        print(scannedPage.uuid)
                        print(scannedPage.documentDetectionStatus)
                        print(scannedPage.polygon)
                        print(scannedPage.source)
                        
                        let originalImage = scannedPage.originalImage
                        let originalImageURI = scannedPage.originalImageURI
                        
                        let documentImage = scannedPage.documentImage
                        let documentImageURI = scannedPage.documentImageURI
                        
                        let documentImagePreview = scannedPage.documentImagePreview
                        let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                        
                        if let documentQuality = scannedPage.documentQualityAssessment {
                            switch documentQuality {
                            case .acceptable: print("acceptable")
                            case .unacceptable: print("unacceptable")
                            case .uncertain: print("uncertain")
                            default: print("unknown")
                            }
                        }
                        // Check out other available properties in `SBSDKScannedPage`
                    }

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
    DocumentAcknowledgmentUI2SwiftUIView()
}
