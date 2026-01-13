//
//  CropScreenUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.08.24.
//

import Foundation
import ScanbotSDK

class CropScreenUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            
            // Create the default configuration object.
            let configuration = SBSDKUI2DocumentScanningFlow()
            
            // Retrieve the instance of the crop configuration from the main configuration object.
            let cropScreenConfiguration = configuration.screens.cropping
            
            // For example disable the rotation feature...
            cropScreenConfiguration.bottomBar.rotateButton.visible = false
            
            // ... configure various colors...
            configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(colorString: "#C8193C")
            cropScreenConfiguration.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)
            
            // ... customize a UI element's text.
            configuration.localization.croppingTopBarCancelButtonTitle = "Cancel"
            
            // Present the view controller modally.
            do {
                let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            }
            catch SBSDKError.operationCanceled {
                print("The operation was cancelled before completion or by the user")
                
            } catch {
                // Any other error
                print("Error scanning document: \(error.localizedDescription)")
            }
        }
    }
}
