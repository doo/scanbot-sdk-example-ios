//
//  DocumentScannerCustomConfigurationUI2ViewController.swift
//  ScanbotSDK Examples
//

import Foundation
import ScanbotSDK

class DocumentScannerCustomConfigurationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1

        // Disable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = false

        // Enable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always

        // Configure the user guidance.
        configuration.screens.camera.topUserGuidance.visible = true
        configuration.screens.camera.userGuidance.visibility = .enabled
        configuration.screens.camera.scanAssistanceOverlay.visible = true

        // Configure the title of the bottom user guidance for different states.
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "No Document"
        configuration.screens.camera.userGuidance.statesTitles.badAspectRatio = "Bad Aspect Ratio"
        configuration.screens.camera.userGuidance.statesTitles.badAngles = "Bad angle"

        // Configure the bottom bar and the bottom bar buttons.
        configuration.appearance.toolbarBackgroundColor = SBSDKUI2Color(colorString: "#C8193C")
        configuration.screens.camera.toolbar.importButton.title.visible = true
        configuration.screens.camera.toolbar.autoSnappingModeButton.title.visible = true
        configuration.screens.camera.toolbar.manualSnappingModeButton.title.visible = true
        configuration.screens.camera.toolbar.torchOnButton.title.visible = true
        configuration.screens.camera.toolbar.torchOffButton.title.visible = true

        // Configure the document capture feedback.
        configuration.screens.camera.captureFeedback.cameraBlinkEnabled = true
        configuration.screens.camera.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFunnelAnimation()

        // Disable the review screen.
        configuration.screens.review.enabled = false
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            
            // Process and show the resulting document here.
            print("Document scanned with \(result.pages.count) pages")
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}

