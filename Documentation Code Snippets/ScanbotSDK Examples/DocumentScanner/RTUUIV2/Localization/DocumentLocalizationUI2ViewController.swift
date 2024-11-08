//
//  DocumentLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.07.24.
//

import Foundation
import ScanbotSDK

class DocumentLocalizationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        localization.cameraTopBarTitle = NSLocalizedString("document.camera.title", comment: "")
        localization.reviewScreenSubmitButtonTitle = NSLocalizedString("review.submit.title", comment: "")
        localization.cameraUserGuidanceNoDocumentFound = NSLocalizedString("camera.userGuidance.noDocumentFound", comment: "")
        localization.cameraUserGuidanceTooDark = NSLocalizedString("camera.userGuidance.tooDark", comment: "")
        
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

