//
//  DocumentImageStraighteningUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentImageStraighteningUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Create the parameters.
        let parameters = SBSDKDocumentStraighteningParameters()

        // Configure the properties.
        // e.g
        parameters.straighteningMode = .straighten

        // By default, aspect ratio of the straightened document is automatically determined based on the detected document corners.
        // If the document is significantly deformed, the estimated aspect ratio may be inaccurate.
        // In such cases, providing a list of expected aspect ratios may help improve the accuracy of the straightening.
        parameters.aspectRatios = [SBSDKAspectRatio(width: 1, height: 1),
                                   SBSDKAspectRatio(width: 16, height: 9),
                                   SBSDKAspectRatio(width: 3, height: 4)]

        // Set the newly created straightening parameters.
        configuration.outputSettings.straighteningParameters = parameters

        // Pass the DOCUMENT_UUID here to resume an old session, or pass nil to start a new session or to resume a draft session.
        configuration.documentUuid = nil

        // Controls whether to resume an existing draft session or start a new one when DOCUMENT_UUID is nil.
        configuration.cleanScanningSession = true

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
                        
                        // Document image is straightened.
                        let documentImage = scannedPage.documentImage
                        let documentImageURI = scannedPage.documentImageURI
                        
                        // Document image preview is straightened.
                        let documentImagePreview = scannedPage.documentImagePreview
                        let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                        
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
    DocumentImageStraighteningUI2SwiftUIView()
}
