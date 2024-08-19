//
//  ReorderScreenUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.08.24.
//

import Foundation
import ScanbotSDK

class ReorderScreenUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the instance of the reorder pages configuration from the main configuration object.
        let reorderScreenConfiguration = configuration.screens.reorderPages
        
        // Hide the guidance view.
        reorderScreenConfiguration.guidance.visible = false
        
        // Set the title for the reorder screen.
        reorderScreenConfiguration.topBarTitle.text = "Reorder Pages Screen"
        
        // Set the title for the guidance.
        reorderScreenConfiguration.guidance.title.text = "Reorder"
        
        // Set the color for the page number text.
        reorderScreenConfiguration.pageTextStyle.color = SBSDKUI2Color(uiColor: .black)
        
        // Apply the configurations.
        configuration.screens.reorderPages = reorderScreenConfiguration
        
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
