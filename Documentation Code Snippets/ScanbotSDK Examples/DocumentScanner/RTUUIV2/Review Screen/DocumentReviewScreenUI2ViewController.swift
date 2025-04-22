//
//  DocumentReviewScreenUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.08.24.
//

import Foundation
import ScanbotSDK

class DocumentReviewScreenUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the instance of the review configuration from the main configuration object.
        let reviewScreenConfiguration = configuration.screens.review
        
        // Enable the review screen.
        reviewScreenConfiguration.enabled = true
        
        // Hide the zoom button.
        reviewScreenConfiguration.zoomButton.visible = false
        
        // Hide the add button.
        reviewScreenConfiguration.bottomBar.addButton.visible = false
        
        // Retrieve the instance of the reorder pages configuration from the main configuration object.
        let reorderScreenConfiguration = configuration.screens.reorderPages
        
        // Hide the guidance view.
        reorderScreenConfiguration.guidance.visible = false
        
        // Set the title for the reorder screen.
        reorderScreenConfiguration.topBarTitle.text = "Reorder Pages Screen"
        
        // Retrieve the instance of the cropping configuration from the main configuration object.
        let croppingScreenConfiguration = configuration.screens.cropping
        
        // Hide the reset button.
        croppingScreenConfiguration.bottomBar.resetButton.visible = false
        
        // Retrieve the retake button configuration from the main configuration object.
        let retakeButtonConfiguration = configuration.screens.review.bottomBar.retakeButton
        
        // Show the retake button.
        retakeButtonConfiguration.visible = true
        
        // Configure the retake title color.
        retakeButtonConfiguration.title.color = SBSDKUI2Color(uiColor: UIColor.white)
        
        // Apply the retake configuration button to the review bottom bar configuration.
        configuration.screens.review.bottomBar.retakeButton = retakeButtonConfiguration
        
        // Apply the configurations.
        configuration.screens.review = reviewScreenConfiguration
        configuration.screens.reorderPages = reorderScreenConfiguration
        configuration.screens.cropping = croppingScreenConfiguration
        
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
