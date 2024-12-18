//
//  DocumentMultiPageUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.07.24.
//

import Foundation
import ScanbotSDK

class DocumentMultiPageUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the page limit to 0, to disable the limit, or set it to the number of pages you want to scan.
        configuration.outputSettings.pagesScanLimit = 0
        
        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none
        
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
