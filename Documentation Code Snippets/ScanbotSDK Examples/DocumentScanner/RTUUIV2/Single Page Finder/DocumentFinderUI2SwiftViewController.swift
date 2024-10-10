//
//  DocumentFinderUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.24.
//

import Foundation
import ScanbotSDK

class DocumentFinderUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the visibility of the view finder.
        configuration.screens.camera.viewFinder.visible = true
        
        // Create the instance of the style, either `SBSDKUI2FinderCorneredStyle` or `SBSDKUI2FinderStrokedStyle`.
        let style = SBSDKUI2FinderCorneredStyle(strokeColor: SBSDKUI2Color(colorString: "#FFFFFFFF"),
                                                strokeWidth: 3.0,
                                                cornerRadius: 10.0)
        
        // Set the configured style.
        configuration.screens.camera.viewFinder.style = style
        
        // Set the desired aspect ratio of the view finder.
        configuration.screens.camera.viewFinder.aspectRatio = SBSDKUI2AspectRatio(width: 4.0, height: 5.0)
        
        // Set the overlay color.
        configuration.screens.camera.viewFinder.overlayColor = SBSDKUI2Color(colorString: "#26000000")
        
        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1
        
        // Enable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = true
        
        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none
        
        // Disable the review screen.
        configuration.screens.review.enabled = false
        
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
