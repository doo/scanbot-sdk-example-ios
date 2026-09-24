//
//  DocumentCleanupScreenUI2ViewController.swift
//  ScanbotSDK Examples
//

import Foundation
import ScanbotSDK

class DocumentCleanupScreenUI2ViewController: UIViewController {
    
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
        
        // The cleanup screen is reachable from the review screen via the `documentCleanupButton`.
        // Make sure the review screen is enabled and the button is visible.
        // Note: the toolbar shows a limited number of items and moves the rest into the 'More' menu,
        // so on a standard phone the cleanup button is usually reachable from the 'More' menu.
        let reviewScreenConfiguration = configuration.screens.review
        reviewScreenConfiguration.enabled = true
        reviewScreenConfiguration.toolbar.documentCleanupButton.barButton.visible = true
        
        // Optionally style the toolbar button...
        reviewScreenConfiguration.toolbar.documentCleanupButton.barButton.title.color = SBSDKUI2Color(uiColor: UIColor.white)
        
        // ... or the relevant popup menu item.
        reviewScreenConfiguration.toolbar.documentCleanupButton.popupMenuItem.title.color = SBSDKUI2Color(uiColor: UIColor.black)
        
        // Retrieve the instance of the cleanup screen configuration from the main configuration object.
        let cleanupScreenConfiguration = configuration.screens.cleanup
        
        // Configure the underlying cleanup engine.
        let engineConfiguration = SBSDKDocumentCleanupConfiguration()
        
        // If true, detected text is preserved. Enabling it runs text detection, which takes additional time.
        engineConfiguration.keepText = false
        
        // The maximum number of undo/redo steps kept in memory. Use a smaller value to save memory.
        engineConfiguration.maxUndoRedoStackSize = 4
        
        // Downscales the stroke area to this value in pixels (width x height) to limit memory consumption
        // and to speed up the cleanup. The smaller the value the faster it is, but the quality is lower too.
        engineConfiguration.maxCleanupResolution = 1_200_000
        
        cleanupScreenConfiguration.engineConfiguration = engineConfiguration
        
        // Customize the top bar.
        cleanupScreenConfiguration.topBarTitle.text = "Clean up the page"
        cleanupScreenConfiguration.topBarBackButton.text = "Cancel"
        cleanupScreenConfiguration.topBarConfirmButton.text = "Done"
        
        // The background color of the canvas behind the image.
        cleanupScreenConfiguration.backgroundColor = SBSDKUI2Color(colorString: "#222222")
        
        // Configure the toolbar buttons.
        cleanupScreenConfiguration.toolbar.undoButton.title.text = "Undo"
        cleanupScreenConfiguration.toolbar.redoButton.title.text = "Redo"
        cleanupScreenConfiguration.toolbar.resetButton.title.text = "Reset"
        
        // Configure the stroke size slider.
        cleanupScreenConfiguration.toolbar.strokeSizeSlider.visible = true
        cleanupScreenConfiguration.toolbar.strokeSizeSlider.minStrokeSize = 1
        cleanupScreenConfiguration.toolbar.strokeSizeSlider.maxStrokeSize = 50
        cleanupScreenConfiguration.toolbar.strokeSizeSlider.title.text = "Brush size"
        
        // Customize the stroke size indicator, the round preview of the current brush.
        cleanupScreenConfiguration.strokeSizeIndicator.backgroundColor = SBSDKUI2Color(colorString: "#00C853")
        cleanupScreenConfiguration.strokeSizeIndicator.borderColor = SBSDKUI2Color(colorString: "#FFFFFF")
        cleanupScreenConfiguration.strokeSizeIndicator.opacity = 0.9
        
        // Optionally show an introduction screen the first time the user opens the cleanup screen.
        cleanupScreenConfiguration.introduction.showAutomatically = true
        
        // Customize the alert dialogs shown when resetting the edits or when cancelling with unsaved changes.
        cleanupScreenConfiguration.resetAllEditsAlertDialog.title.text = "Reset all edits?"
        cleanupScreenConfiguration.resetAllEditsAlertDialog.subtitle.text = "This will revert all cleanup operations on this page."
        
        cleanupScreenConfiguration.discardChangesAlertDialog.title.text = "Discard changes?"
        cleanupScreenConfiguration.discardChangesAlertDialog.subtitle.text = "Your cleanup edits on this page will be lost."
        
        // Optionally customize the text of the cleanup screen via the shared localization object.
        configuration.localization.documentCleanupScreenTitle = "Clean up the page"
        configuration.localization.documentCleanupUndoButtonTitle = "Undo"
        configuration.localization.documentCleanupRedoButtonTitle = "Redo"
        configuration.localization.documentCleanupResetButtonTitle = "Reset"
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            
            // Handle the scanned document. The cleanup edits are persisted on the page.
            result.pages.forEach { scannedPage in
                let documentImage = scannedPage.documentImage
            }
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error, e.g. an invalid license.
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
