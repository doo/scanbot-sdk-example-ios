//
//  DocumentPreviewModesUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentPreviewModesUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Retrieve the camera screen configuration.
        let cameraScreenConfig = configuration.screens.camera

        // Possible preview modes...

        // Image with document count badge.
        let imagePreviewMode = SBSDKUI2PagePreviewMode()
        imagePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        imagePreviewMode.pageCounter.background.fillColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Text with document count badge.
        let textWithBadgePreviewMode = SBSDKUI2TextWithBadgeButtonMode()
        textWithBadgePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        textWithBadgePreviewMode.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        textWithBadgePreviewMode.title.visible = true

        // Only text.
        let textMode = SBSDKUI2TextButtonMode()
        textMode.title.color = SBSDKUI2Color(colorString: "#FFFFFF")

        // No button.
        let noButtonMode = SBSDKUI2NoButtonMode()

        // Set the desired mode.
        cameraScreenConfig.toolbar.previewButton = imagePreviewMode

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
    DocumentPreviewModesUI2SwiftUIView()
}
