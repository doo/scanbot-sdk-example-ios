//
//  DocumentMultiPageUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.07.24.
//

import Foundation
import ScanbotSDK

class DocumentMultiPageUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the page limit to 0, to disable the limit, or set it to the number of pages to be scanned.
        configuration.outputSettings.pagesScanLimit = 0
        
        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none
        
        // Present the view controller modally.
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
