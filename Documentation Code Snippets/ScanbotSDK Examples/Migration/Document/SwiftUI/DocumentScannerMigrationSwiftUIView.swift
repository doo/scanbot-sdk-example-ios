//
//  DocumentScannerMigrationSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

// With RTU UI v.2.0 we don't need to implement a delegate in our ViewController anymore
struct DocumentScannerMigrationSwiftUIView: View {

    @State private var image: UIImage?
    @State private var activeScannerScreen: ScannerScreen?

    @State private var documentScannerConfiguration: SBSDKUI2DocumentScanningFlow = {
        // See the next section for the configuration migration details.
        // ...
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        return configuration
    }()

    @State private var configExampleConfiguration: SBSDKUI2DocumentScanningFlow = {
        let configuration = SBSDKUI2DocumentScanningFlow()

        let cameraScreenConfiguration = configuration.screens.camera

        // Equivalent to behaviorConfiguration.ignoreBadAspectRatio = true
        cameraScreenConfiguration.scannerParameters.ignoreOrientationMismatch = true

        // Equivalent to behaviorConfiguration.autoSnappingSensitivity = 0.75
        cameraScreenConfiguration.cameraConfiguration.autoSnappingSensitivity = 0.75

        // Ready-to-Use UI v2 contains an acknowledgment screen to
        // verify the captured document with the built-in Document Quality Analyzer.
        // You can still disable this step:
        cameraScreenConfiguration.acknowledgement.acknowledgementMode = SBSDKUI2AcknowledgementMode.none

        // When you disable the acknowledgment screen, you can enable the capture feedback,
        // there are different options available, for example you can display a checkmark animation:
        cameraScreenConfiguration.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFeedbackMode.pageSnapCheckMarkAnimation()

        // You may hide the import button in the camera screen, if you don't need it:
        cameraScreenConfiguration.toolbar.importButton.visible = false

        // Equivalent to uiConfiguration.bottomBarBackgroundColor = UIColor.blue, but not recommended:
        configuration.appearance.toolbarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.blue)

        // However, now all the colors can be conveniently set using the Palette object:
        let palette = configuration.palette
        palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)
        palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: UIColor.white)
        // ..

        // Now all the text resources are in the localization object.
        let localization = configuration.localization
        localization.cameraUserGuidanceReadyToCapture = "Don't move. Capturing document..."

        // Ready-to-Use UI v2 contains a review screen, you can disable it:
        configuration.screens.review.enabled = false

        // Multi Page button is always hidden in RTU v2
        // Therefore uiConfiguration.isMultiPageButtonHidden = true is not available

        // Equivalent to behaviorConfiguration.isMultiPageEnabled = false
        configuration.outputSettings.pagesScanLimit = 1

        return configuration
    }()

    @State private var finderConfiguration: SBSDKUI2DocumentScanningFlow = {
        let configuration = SBSDKUI2DocumentScanningFlow()

        let palette = configuration.palette
        palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)
        palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: UIColor.white)
        // ..

        let cameraScreenConfiguration = configuration.screens.camera

        let viewFinder = cameraScreenConfiguration.viewFinder
        viewFinder.visible = true
        viewFinder.aspectRatio = SBSDKAspectRatio(width: 3, height: 4)

        let toolbar = cameraScreenConfiguration.toolbar
        toolbar.previewButton = SBSDKUI2PreviewButton.noButtonMode()
        toolbar.autoSnappingModeButton.visible = false
        toolbar.importButton.visible = false

        cameraScreenConfiguration.acknowledgement.acknowledgementMode = SBSDKUI2AcknowledgementMode.none
        cameraScreenConfiguration.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFeedbackMode.pageSnapCheckMarkAnimation()

        configuration.screens.review.enabled = false
        configuration.outputSettings.pagesScanLimit = 1

        return configuration
    }()

    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Button("Open Scanner") {
                openScannerTapped()
            }
        }
        .fullScreenCover(item: $activeScannerScreen) { screen in
            documentScannerView(configuration: configuration(for: screen))
        }
    }

    // We will process a scanned document here:
    func processDocument(document: SBSDKScannedDocument) {
        // This is how we can access the document preview image from the SBSDKScannedDocument
        image = try? document.pages.first?.documentImagePreview?.toUIImage()
    }

    func openScannerTapped() {
        openDocumentScannerRtuV2()
    }

    func openDocumentScannerRtuV2() {
        activeScannerScreen = .default
    }

    func configExampleDocumentScannerRtuV2() {
        activeScannerScreen = .configExample
    }

    func openFinderDocumentScannerRtuV2() {
        activeScannerScreen = .finder
    }

    func createFromDocument(_ document: SBSDKDocument) throws -> SBSDKScannedDocument? {

        // Create the scanned document using convenience initializer `init(document:documentImageSizeLimit:)`.
        // `SBSDKDocument` doesn't support `documentImageSizeLimit`, but you can add it to unify the size of the documents.
        let scannedDocument = try SBSDKScannedDocument(document: document, documentImageSizeLimit: 2048)

        // Return newly created scanned document.
        return scannedDocument
    }

    func configuration(for screen: ScannerScreen) -> SBSDKUI2DocumentScanningFlow {
        switch screen {
        case .default:
            return documentScannerConfiguration
        case .configExample:
            return configExampleConfiguration
        case .finder:
            return finderConfiguration
        }
    }

    @ViewBuilder
    func documentScannerView(configuration: SBSDKUI2DocumentScanningFlow) -> some View {
        SBSDKUI2DocumentScannerView(configuration: configuration,
                                                              completion: { scannedDocument, error in
            if let scannedDocument {
                processDocument(document: scannedDocument)
            } else if let error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")

                } else {
                    // Any other error
                    print("Error scanning document: \(error.localizedDescription)")
                }
            }
            activeScannerScreen = nil
        })
                .ignoresSafeArea()

    }

    enum ScannerScreen: String, Identifiable {
        case `default`
        case configExample
        case finder

        var id: String { rawValue }
    }
}

#Preview {
    DocumentScannerMigrationSwiftUIView()
}
