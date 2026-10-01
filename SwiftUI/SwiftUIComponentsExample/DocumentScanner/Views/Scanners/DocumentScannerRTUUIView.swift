//
//  DocumentScannerRTUUIView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 27.08.24.
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI document scanner using the native SwiftUI component `SBSDKUI2DocumentScannerView`.
struct DocumentScannerRTUUIView: View {
    
    let variant: DocumentScanningFlowVariant
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var scanningResult: DocumentScanningResult
    
    @State private var scanner: SBSDKUI2DocumentScannerView?
    
    var body: some View {
        Group {
            if let scanner {
                scanner
            } else {
                Color.black
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: createScannerIfNeeded)
    }
    
    private func createScannerIfNeeded() {
        guard scanner == nil else { return }
        do {
            scanner = try SBSDKUI2DocumentScannerView(configuration: configuration(), completion: handleResult)
        } catch {
            handleResult(scannedDocument: nil, error: error)
        }
    }
    
    private func configuration() -> SBSDKUI2DocumentScanningFlow {
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the colors.
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: .systemBlue)
        configuration.palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: .white)
        
        switch variant {
        case .singlePage:
            configureSinglePage(configuration)
        case .singlePageWithFinder:
            configureSinglePage(configuration)
            configureFinder(configuration)
        case .multiplePage:
            configureMultiplePage(configuration)
        }
        
        return configuration
    }
    
    /// Scans exactly one page and returns right after the capture.
    private func configureSinglePage(_ configuration: SBSDKUI2DocumentScanningFlow) {
        configuration.outputSettings.pagesScanLimit = 1
        configuration.screens.review.enabled = false
        
        // Hide the auto snapping enable/disable buttons.
        configuration.screens.camera.toolbar.autoSnappingModeButton.visible = false
        configuration.screens.camera.toolbar.manualSnappingModeButton.visible = false
        configuration.screens.camera.toolbar.importButton.title.visible = true
        configuration.screens.camera.toolbar.torchOnButton.title.visible = true
        configuration.screens.camera.toolbar.torchOffButton.title.visible = true
        
        // Configure the hint texts for different scenarios.
        configuration.screens.camera.userGuidance.statesTitles.tooDark = "Need more lighting to detect a document"
        configuration.screens.camera.userGuidance.statesTitles.tooSmall = "Document too small"
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "Could not detect a document"
    }
    
    /// Restricts the scanning to a 3:4 finder overlay.
    private func configureFinder(_ configuration: SBSDKUI2DocumentScanningFlow) {
        configuration.screens.camera.viewFinder.visible = true
        configuration.screens.camera.viewFinder.aspectRatio = SBSDKAspectRatio(width: 3, height: 4)
    }
    
    /// Scans any number of pages and shows the full review, reorder and cropping screens.
    private func configureMultiplePage(_ configuration: SBSDKUI2DocumentScanningFlow) {
        configuration.screens.camera.toolbar.importButton.title.visible = true
        
        // Enable the review screen.
        configuration.screens.review.enabled = true
        
        // The review toolbar buttons are adaptive: they can be shown in the toolbar or in the more popup.
        configuration.screens.review.toolbar.addButton.barButton.visible = true
        configuration.screens.review.toolbar.retakeButton.barButton.visible = true
        configuration.screens.review.toolbar.cropButton.barButton.visible = true
        configuration.screens.review.toolbar.rotateButton.barButton.visible = true
        configuration.screens.review.toolbar.deleteButton.barButton.visible = true
        configuration.screens.review.toolbar.reorderButton.barButton.visible = true
        
        // Configure the reorder pages screen.
        configuration.screens.reorderPages.topBarTitle.text = "Reorder Pages"
        
        // Configure the cropping screen.
        configuration.screens.cropping.topBarTitle.text = "Cropping Screen"
        configuration.screens.cropping.toolbar.resetButton.visible = true
        configuration.screens.cropping.toolbar.rotateButton.visible = true
        configuration.screens.cropping.toolbar.detectButton.visible = true
    }
    
    private func handleResult(scannedDocument: SBSDKScannedDocument?, error: Error?) {
        if let scannedDocument {
            scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
        } else if let error {
            scanningResult = DocumentScanningResult(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
