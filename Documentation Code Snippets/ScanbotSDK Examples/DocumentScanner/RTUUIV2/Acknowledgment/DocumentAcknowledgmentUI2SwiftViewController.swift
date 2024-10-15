//
//  DocumentAcknowledgmentUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.24.
//

import Foundation
import ScanbotSDK

class DocumentAcknowledgmentUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()

        // Set the acknowledgment mode
        // Modes:
        // - `always`: Runs the quality analyzer on the captured document and always displays the acknowledgment screen.
        // - `badQuality`: Runs the quality analyzer and displays the acknowledgment screen only if the quality is poor.
        // - `none`: Skips the quality check entirely.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always
        
        // Set the minimum acceptable document quality.
        // Options: excellent, good, reasonable, poor, veryPoor, or noDocument.
        configuration.screens.camera.acknowledgement.minimumQuality = .reasonable
        
        // Set the background color for the acknowledgment screen.
        configuration.screens.camera.acknowledgement.backgroundColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // You can also configure the buttons in the bottom bar of the acknowledgment screen.
        // e.g To force the user to retake, if the captured document is not OK.
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenNotOkButton.visible = false
        
        // Hide the titles of the buttons.
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenNotOkButton.title.visible = false
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenOkButton.title.visible = false
        configuration.screens.camera.acknowledgement.bottomBar.retakeButton.title.visible = false
        
        // Configure the acknowledgment screen's hint message which is shown if the least acceptable quality is not met.
        configuration.screens.camera.acknowledgement.badImageHint.visible = true
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2DocumentScannerController.present(on: self,
                                                  configuration: configuration) { document in
            
            // Completion handler to process the result.
            
            if let document {
                // Handle the document.
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
