//
//  DocumentPaletteUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentPaletteUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Retrieve the instance of the palette from the configuration object.
        let palette = configuration.palette

        // Configure the colors.
        // The palette already has the default colors set, so you only need to modify the colors that you want to change.
        palette.sbColorPrimary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorPrimaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorNegative = SBSDKUI2Color(colorString: "#FF3737")
        palette.sbColorPositive = SBSDKUI2Color(colorString: "#4EFFB4")
        palette.sbColorWarning = SBSDKUI2Color(colorString: "#FFCE5C")
        palette.sbColorSecondary = SBSDKUI2Color(colorString: "#FFEDEE")
        palette.sbColorSecondaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorOnPrimary = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOnSecondary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorSurface = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOutline = SBSDKUI2Color(colorString: "#EFEFEF")
        palette.sbColorOnSurfaceVariant = SBSDKUI2Color(colorString: "#707070")
        palette.sbColorOnSurface = SBSDKUI2Color(colorString: "#000000")
        palette.sbColorSurfaceLow = SBSDKUI2Color(colorString: "#26000000")
        palette.sbColorSurfaceHigh = SBSDKUI2Color(colorString: "#7A000000")
        palette.sbColorModalOverlay = SBSDKUI2Color(colorString: "#A3000000")

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
    DocumentPaletteUI2SwiftUIView()
}
