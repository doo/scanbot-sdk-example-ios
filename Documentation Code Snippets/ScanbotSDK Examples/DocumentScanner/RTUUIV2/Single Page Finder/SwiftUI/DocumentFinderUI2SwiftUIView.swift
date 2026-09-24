//
//  DocumentFinderUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentFinderUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Set the visibility of the view finder.
        configuration.screens.camera.viewFinder.visible = true

        // Create the instance of the style, either `SBSDKUI2FinderCorneredStyle` or `SBSDKUI2FinderStrokedStyle`.
        let style = SBSDKUI2FinderCorneredStyle(strokeColor: SBSDKUI2Color(colorString: "#FFFFFFFF"),
                                                strokeWidth: 3.0,
                                                cornerRadius: 10.0)

        // Set the configured style.
        configuration.screens.camera.viewFinder.style = style

        // Set the desired aspect ratio of the view finder.
        configuration.screens.camera.viewFinder.aspectRatio = SBSDKAspectRatio(width: 4.0, height: 5.0)

        // Set the overlay color.
        configuration.screens.camera.viewFinder.overlayColor = SBSDKUI2Color(colorString: "#26000000")

        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1

        // Enable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = true

        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none

        // Disable the review screen.
        configuration.screens.review.enabled = false

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
    DocumentFinderUI2SwiftUIView()
}
