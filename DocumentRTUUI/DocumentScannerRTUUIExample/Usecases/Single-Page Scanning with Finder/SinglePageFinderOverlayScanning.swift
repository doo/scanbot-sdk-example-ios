//
//  SinglePageFinderOverlayScanning.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 30.08.23.
//

import ScanbotSDK

class SinglePageFinderOverlayScanning {
    
    static func present(presenter: UIViewController) {
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Disable the multiple page behavior
        configuration.outputSettings.pagesScanLimit = 1
        
        // Enable view finder
        configuration.screens.camera.viewFinder.visible = true
        configuration.screens.camera.viewFinder.aspectRatio = SBSDKAspectRatio(width: 3, height: 4)
        
        // Enable/Disable the review screen.
        configuration.screens.review.enabled = false
        
        // Enable/Disable Auto Snapping behavior
        configuration.screens.camera.cameraConfiguration.autoSnappingEnabled = true
        
        // Hide the auto snapping enable/disable button
        configuration.screens.camera.bottomBar.autoSnappingModeButton.visible = false
        configuration.screens.camera.bottomBar.manualSnappingModeButton.visible = false
        
        // Set colors
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: .appAccentColor)
        configuration.palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: .white)
        
        // Configure the hint texts for different scenarios
        configuration.screens.camera.userGuidance.statesTitles.tooDark = "Need more lighting to detect a document"
        configuration.screens.camera.userGuidance.statesTitles.tooSmall = "Document too small"
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "Could not detect a document"
        
        // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
        do {
            try SBSDKUI2DocumentScannerController.present(on: presenter,
                                                          configuration: configuration) { _, document, error in
                
                // Completion handler to process the result.
                if let document {
                    // Process the document
                    let resultViewController = SingleScanResultViewController.make(with: document)
                    presenter.navigationController?.pushViewController(resultViewController, animated: true)
                } else {
                    // Indicates that an error occured or the cancel button was tapped.
                    if let sdkError = error as? SBSDKError, sdkError.isCanceled {
                        // Canceled. Do nothing.
                    } else if let error {
                        // Show an error alert.
                        presenter.sbsdk_showError(error)
                    }
                }
            }
        } catch {
            // Handle potential errors during the presentation of the document scanner
            presenter.sbsdk_showError(error)
        }
    }
}
