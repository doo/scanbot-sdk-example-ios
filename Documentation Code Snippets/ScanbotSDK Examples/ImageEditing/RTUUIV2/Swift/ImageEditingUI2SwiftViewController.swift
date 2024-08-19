//
//  ImageEditingUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.08.24.
//

import Foundation

import Foundation
import ScanbotSDK

class ImageEditingUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Retrieve the scanned document
        guard let document = SBSDKScannedDocument(documentID: "SOME_SAVED_UUID") else { return }
        
        // Retrieve the selected document page.
        guard let page = document.page(at: 0) else { return }
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CroppingConfiguration(documentUuid: document.uuid, pageUuid: page.uuid)
        
        // e.g disable the rotation feature.
        configuration.cropping.bottomBar.rotateButton.visible = false
        
        // e.g. configure various colors.
        configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.red)
        configuration.cropping.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)
        
        // e.g. customize a UI element's text
        configuration.localization.croppingCancelButtonTitle = "Cancel"
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2CroppingViewController.present(on: self, configuration: configuration) { result in
            
            // Completion handler to process the result.
            if let error = result.errorMessage {
                // There was an error.
                print(error)
            } else {
                // The screen is dismissed without errors.
            }
        }
    }
}
