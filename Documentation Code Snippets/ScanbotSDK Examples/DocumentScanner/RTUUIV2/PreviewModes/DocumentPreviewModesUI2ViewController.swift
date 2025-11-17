//
//  DocumentPreviewModesUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 29.10.25.
//

import Foundation
import ScanbotSDK

class DocumentPreviewModesUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the camera screen configuration.
        let cameraScreenConfig = configuration.screens.camera
        
        // Possible preview modes...
        
        // Image with document count badge.
        let imagePreviewMode = SBSDKUI2PagePreviewMode()
        imagePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        imagePreviewMode.pageCounter.background.fillColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Text with document count badge.
        let textWithBadgePreviewMode = SBSDKUI2TextWithBadgeButtonMode()
        textWithBadgePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        textWithBadgePreviewMode.text.color = SBSDKUI2Color(colorString: "#FFFFFF")
        textWithBadgePreviewMode.text.visible = true
        
        // Only text.
        let textMode = SBSDKUI2TextButtonMode()
        textMode.style.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // No button.
        let noButtonMode = SBSDKUI2NoButtonMode()
        
        // Set the desired mode.
        cameraScreenConfig.bottomBar.previewButton = imagePreviewMode
        
        // Present the view controller modally.
        do {
            let controller = try SBSDKUI2DocumentScannerController.present(on: self,
                                                                           configuration: configuration)
            { controller, document, error in
                
                // Completion handler to process the result.
                
                if let document {
                    // Handle the document.
                    
                } else if let error {
                    
                    // Handle the error.
                    print("Error scanning document: \(error.localizedDescription)")
                }
            }
        }
        catch {
            print("Error while presenting the document scanner: \(error.localizedDescription)")
        }
    }
}
