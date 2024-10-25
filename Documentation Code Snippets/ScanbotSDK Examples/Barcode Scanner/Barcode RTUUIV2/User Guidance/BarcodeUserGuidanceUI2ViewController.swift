//
//  BarcodeUserGuidanceUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.12.23.
//

import Foundation
import ScanbotSDK

class BarcodeUserGuidanceUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Retrieve the instance of the user guidance from the configuration object.
        let userGuidance = configuration.userGuidance
        
        // Hide/unhide the user guidance.
        userGuidance.visible = true
        
        // Configure the title.
        userGuidance.title.text = "Move the finder over a barcode"
        userGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the background.
        userGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
        // Create and set an array of accepted barcode formats.
        configuration.recognizerConfiguration.barcodeFormats = SBSDKBarcodeFormats.twod
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
