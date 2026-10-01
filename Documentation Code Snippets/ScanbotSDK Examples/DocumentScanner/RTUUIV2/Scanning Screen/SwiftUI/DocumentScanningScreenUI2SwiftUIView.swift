//
//  DocumentScanningScreenUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentScanningScreenUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2DocumentScanningFlow = {
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Set the limit for the number of pages to be scanned.
        configuration.outputSettings.pagesScanLimit = 30

        // Pass the DOCUMENT_UUID here to resume an old session, or pass nil to start a new session or to resume a draft session.
        configuration.documentUuid = nil

        // Controls whether to resume an existing draft session or start a new one when DOCUMENT_UUID is nil.
        configuration.cleanScanningSession = true

        // Retrieve the camera screen configuration.
        let cameraScreenConfig = configuration.screens.camera

        // Configure the top user guidance.
        cameraScreenConfig.topUserGuidance.visible = true
        cameraScreenConfig.topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#4A000000")
        cameraScreenConfig.topUserGuidance.title.text = "Scan your document"

        // Configure the bottom user guidance.
        cameraScreenConfig.userGuidance.visibility = .enabled
        cameraScreenConfig.userGuidance.background.fillColor = SBSDKUI2Color(colorString: "#4A000000")
        cameraScreenConfig.userGuidance.title.text = "Please hold your device over a document"

        // Configure the scanning assistance overlay.
        cameraScreenConfig.scanAssistanceOverlay.visible = true
        cameraScreenConfig.scanAssistanceOverlay.backgroundColor = SBSDKUI2Color(colorString: "#4A000000")
        cameraScreenConfig.scanAssistanceOverlay.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Configure the title of the bottom user guidance for different states.
        cameraScreenConfig.userGuidance.statesTitles.noDocumentFound = "No Document"
        cameraScreenConfig.userGuidance.statesTitles.badAspectRatio = "Bad Aspect Ratio"
        cameraScreenConfig.userGuidance.statesTitles.badAngles = "Bad angle"
        cameraScreenConfig.userGuidance.statesTitles.textHintOffCenter = "The document is off center"
        cameraScreenConfig.userGuidance.statesTitles.tooSmall = "The document is too small"
        cameraScreenConfig.userGuidance.statesTitles.tooNoisy = "The document is too noisy"
        cameraScreenConfig.userGuidance.statesTitles.tooDark = "Need more light"
        cameraScreenConfig.userGuidance.statesTitles.energySaveMode = "Energy save mode is active"
        cameraScreenConfig.userGuidance.statesTitles.readyToCapture = "Ready to capture"
        cameraScreenConfig.userGuidance.statesTitles.capturing = "Capturing the document"

        // The title of the user guidance when the document is ready to be captured in manual mode.
        cameraScreenConfig.userGuidance.statesTitles.captureManual = "The document is ready to be captured"


        // Set the background color of the bottom bar.
        configuration.appearance.toolbarBackgroundColor = SBSDKUI2Color(colorString: "#C8193C")

        // Import button used to import image from the gallery.
        cameraScreenConfig.toolbar.importButton.visible = true
        cameraScreenConfig.toolbar.importButton.title.visible = true
        cameraScreenConfig.toolbar.importButton.title.text = "Import"

        // Configure the auto/manual snap button.
        cameraScreenConfig.toolbar.autoSnappingModeButton.title.visible = true
        cameraScreenConfig.toolbar.autoSnappingModeButton.title.text = "Auto"
        cameraScreenConfig.toolbar.manualSnappingModeButton.title.visible = true
        cameraScreenConfig.toolbar.manualSnappingModeButton.title.text = "Manual"

        // Configure the torch off/on button.
        cameraScreenConfig.toolbar.torchOnButton.title.visible = true
        cameraScreenConfig.toolbar.torchOnButton.title.text = "On"
        cameraScreenConfig.toolbar.torchOffButton.title.visible = true
        cameraScreenConfig.toolbar.torchOffButton.title.text = "Off"


        // Configure the camera blink behavior when an image is captured.
        cameraScreenConfig.captureFeedback.cameraBlinkEnabled = true

        // Configure the animation mode. You can choose between a checkmark animation or a document funnel animation.
        // Configure the checkmark animation. You can use the default colors or set your own desired colors for the checkmark.
        cameraScreenConfig.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapCheckMarkAnimation()

        // Or choose the funnel animation.
        cameraScreenConfig.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFunnelAnimation()

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
    DocumentScanningScreenUI2SwiftUIView()
}
