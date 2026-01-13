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
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
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
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.uuid)
            print(result.pageCount)
            print(result.documentImageSizeLimit)
            print(result.pdfURI)
            print(result.tiffURI)
            print(result.creationDate)
            
            // Check out other available properties in `SBSDKScannedDocument`.
            
            result.pages.forEach { scannedPage in
                
                print(scannedPage.uuid)
                print(scannedPage.documentDetectionStatus)
                print(scannedPage.polygon)
                print(scannedPage.source)
                
                let originalImage = scannedPage.originalImage
                let originalImageURI = scannedPage.originalImageURI
                
                let documentImage = scannedPage.documentImage
                let documentImageURI = scannedPage.documentImageURI
                
                let documentImagePreview = scannedPage.documentImagePreview
                let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                
                if let documentQuality = scannedPage.documentQuality {
                    switch documentQuality {
                    case .veryPoor: print("veryPoor")
                    case .poor: print("poor")
                    case .reasonable: print("reasonable")
                    case .good: print("good")
                    case .excellent: print("excellent")
                    default: print("unknown")
                    }
                }
                // Check out other available properties in `SBSDKScannedPage`
            }
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
