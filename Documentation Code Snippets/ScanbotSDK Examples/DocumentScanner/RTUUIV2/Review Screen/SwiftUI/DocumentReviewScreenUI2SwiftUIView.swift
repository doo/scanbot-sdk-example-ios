//
//  DocumentReviewScreenUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentReviewScreenUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Retrieve the instance of the review configuration from the main configuration object.
        let reviewScreenConfiguration = configuration.screens.review

        // Enable the review screen.
        reviewScreenConfiguration.enabled = true

        // Hide the zoom button.
        reviewScreenConfiguration.zoomButton.visible = false

        // Hide the add button.
        reviewScreenConfiguration.toolbar.addButton.barButton.visible = false

        // Retrieve the instance of the reorder pages configuration from the main configuration object.
        let reorderScreenConfiguration = configuration.screens.reorderPages

        // Hide the guidance view.
        reorderScreenConfiguration.guidance.visible = false

        // Set the title for the reorder screen.
        reorderScreenConfiguration.topBarTitle.text = "Reorder Pages Screen"

        // Retrieve the instance of the cropping configuration from the main configuration object.
        let croppingScreenConfiguration = configuration.screens.cropping

        // Hide the reset button.
        croppingScreenConfiguration.toolbar.resetButton.visible = false

        // Retrieve the retake button configuration from the main configuration object.
        let retakeButtonConfiguration = configuration.screens.review.toolbar.retakeButton.barButton

        // Show the retake button.
        retakeButtonConfiguration.visible = true

        // Configure the retake title color.
        retakeButtonConfiguration.title.color = SBSDKUI2Color(uiColor: UIColor.white)

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
    DocumentReviewScreenUI2SwiftUIView()
}
