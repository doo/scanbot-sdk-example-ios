//
//  DocumentScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 22.08.24.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2DocumentScanningFlow` which contains the configuration settings for the document scanner.
    let configuration: SBSDKUI2DocumentScanningFlow = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1
        
        // Disable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = false
        
        // Enable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always
        
        // Configure the user guidance.
        // e.g
        configuration.screens.camera.topUserGuidance.visible = true
        configuration.screens.camera.userGuidance.visibility = .enabled
        configuration.screens.camera.scanAssistanceOverlay.visible = true
        
        // Configure the title of the bottom user guidance for different states.
        // e.g
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "No Document"
        configuration.screens.camera.userGuidance.statesTitles.badAspectRatio = "Bad Aspect Ratio"
        configuration.screens.camera.userGuidance.statesTitles.badAngles = "Bad angle"
        
        // Configure the bottom bar and the bottom bar buttons.
        // e.g
        configuration.appearance.bottomBarBackgroundColor = SBSDKUI2Color(colorString: "#C8193C")
        configuration.screens.camera.bottomBar.importButton.title.visible = true
        configuration.screens.camera.bottomBar.autoSnappingModeButton.title.visible = true
        configuration.screens.camera.bottomBar.manualSnappingModeButton.title.visible = true
        configuration.screens.camera.bottomBar.torchOnButton.title.visible = true
        configuration.screens.camera.bottomBar.torchOffButton.title.visible = true
        
        // Configure the document capture feedback.
        // e.g
        configuration.screens.camera.captureFeedback.cameraBlinkEnabled = true
        configuration.screens.camera.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFunnelAnimation()
        
        // Disable the review screen.
        configuration.screens.review.enabled = false
        
        return configuration
    }()
    
    // An optional `SBSDKScannedDocument` object containing the resulted document of the scanning process.
    @State var scannedDocument: SBSDKScannedDocument?
    
    var body: some View {
        
        if let document = self.scannedDocument {
            // Process and show the resulted document here.

        } else {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2DocumentScannerView(configuration: configuration,
                                        completion: { document in
                if let document {
                    scannedDocument = document
                    
                } else {
                    
                    // Dismiss your view here.
                }
            })
            .ignoresSafeArea()
        }
    }
}

#Preview {
    DocumentScannerSwiftUIView()
}
