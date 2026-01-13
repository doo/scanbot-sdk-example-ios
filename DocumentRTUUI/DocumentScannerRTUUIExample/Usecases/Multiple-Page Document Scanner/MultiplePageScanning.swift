//
//  MultiplePageScanning.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

class MultiplePageScanning {
    
    static func present(presenter: UIViewController) {
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Enable the multiple page behavior
        configuration.outputSettings.pagesScanLimit = 0
        
        // Enable/Disable Auto Snapping behavior
        configuration.screens.camera.cameraConfiguration.autoSnappingEnabled = true
        
        // Hide/Unhide the auto snapping enable/disable button
        configuration.screens.camera.bottomBar.autoSnappingModeButton.visible = true
        configuration.screens.camera.bottomBar.manualSnappingModeButton.visible = true
        
        // Set colors
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: .appAccentColor)
        configuration.palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: .white)
        
        // Configure the hint texts for different scenarios
        // e.g
        configuration.screens.camera.userGuidance.statesTitles.tooDark = "Need more lighting to detect a document"
        configuration.screens.camera.userGuidance.statesTitles.tooSmall = "Document too small"
        configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = "Could not detect a document"
        
        // Enable/Disable the review screen.
        configuration.screens.review.enabled = true
        
        // Configure bottom bar (further properties like title, icon and  background can also be set for these buttons)
        configuration.screens.review.bottomBar.addButton.visible = true
        configuration.screens.review.bottomBar.retakeButton.visible = true
        configuration.screens.review.bottomBar.cropButton.visible = true
        configuration.screens.review.bottomBar.rotateButton.visible = true
        configuration.screens.review.bottomBar.deleteButton.visible = true
        
        // Configure `more` popup on review screen
        // e.g
        configuration.screens.review.morePopup.reorderPages.icon.visible = true
        configuration.screens.review.morePopup.deleteAll.icon.visible = true
        configuration.screens.review.morePopup.deleteAll.title.text = "Delete all pages"
        
        // Configure reorder pages screen
        // e.g
        configuration.screens.reorderPages.topBarTitle.text = "Reorder Pages"
        configuration.screens.reorderPages.guidance.title.text = "Reorder Pages"
        
        // Configure cropping screen
        // e.g
        configuration.screens.cropping.topBarTitle.text = "Cropping Screen"
        configuration.screens.cropping.bottomBar.resetButton.visible = true
        configuration.screens.cropping.bottomBar.rotateButton.visible = true
        configuration.screens.cropping.bottomBar.detectButton.visible = true
        
        do {
            // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
            try SBSDKUI2DocumentScannerController.present(on: presenter,
                                                          configuration: configuration) { _, document, error in
            
                // Completion handler to process the result.
                        
                if let document {
                
                    if document.pageCount == 1 {
                    
                        let resultViewController = SingleScanResultViewController.make(with: document)
                        presenter.navigationController?.pushViewController(resultViewController, animated: true)
                    
                    } else if document.pageCount > 1 {
                    
                        let resultViewController = MultiScanResultViewController.make(with: document)
                        presenter.navigationController?.pushViewController(resultViewController, animated: true)
                    }
                
                } else if let sdkError = error as? SBSDKError, sdkError.isCanceled {

                    // Indicates that the cancel button was tapped.

                } else if let error {
                    
                    // An error occurred during scanning. Handle it here.
                    presenter.sbsdk_showError(error)
                }
            }
        } catch {
            
            // An error occurred while presenting the document scanner. Handle it here.
            presenter.sbsdk_showError(error)
        }
    }
}
