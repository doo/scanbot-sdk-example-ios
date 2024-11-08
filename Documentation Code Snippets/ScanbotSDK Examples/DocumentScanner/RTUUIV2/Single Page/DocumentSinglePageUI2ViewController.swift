//
//  DocumentSinglePageUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.07.24.
//

import Foundation
import ScanbotSDK

class DocumentSinglePageUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1
        
        // Disable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = false
        
        // Enable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always
        
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
