//
//  SinglePageScanning.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 04.09.23.
//

import ScanbotSDK

class SinglePageScanning {
    
    static func present(presenter: UIViewController) {
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Disable the multiple page behavior
        configuration.outputSettings.pagesScanLimit = 1
        
        // Enable/Disable the review screen.
        configuration.screens.review.enabled = false
        
        // Enable/Disable Auto Snapping behavior
        configuration.screens.camera.cameraConfiguration.autoSnappingEnabled = true
        
        
        // Configure the animation
        // You can choose between genie animation or checkmark animation
        // Note: Both modes can be further configured to your liking
        
        // e.g for genie animation
        configuration.screens.camera.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFunnelAnimation()
        // or for checkmark animation
        configuration.screens.camera.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapCheckMarkAnimation()
        
        // Hide the auto snapping enable/disable button
        configuration.screens.camera.bottomBar.autoSnappingModeButton.visible = false
        configuration.screens.camera.bottomBar.manualSnappingModeButton.visible = false
        configuration.screens.camera.bottomBar.importButton.title.visible = true
        configuration.screens.camera.bottomBar.torchOnButton.title.visible = true
        configuration.screens.camera.bottomBar.torchOffButton.title.visible = true
        
        // Set colors
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: .appAccentColor)
        configuration.palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: .white)
        
        // Configure the hint texts for different scenarios
        configuration.screens.camera.userGuidance.statesTitles.tooDark = "Need more lighting to detect a document"
        configuration.screens.camera.userGuidance.statesTitles.tooSmall = "Document too small"
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "Could not detect a document"
        
        // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
        SBSDKUI2DocumentScannerController.present(on: presenter,
                                                  configuration: configuration) { document in
            
            // Completion handler to process the result.
                        
            if let document {
                
                // Process the document
                let resultViewController = SingleScanResultViewController.make(with: document)
                presenter.navigationController?.pushViewController(resultViewController, animated: true)
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
