//
//  ActionBarConfigurationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 21.12.23.
//

import Foundation
import ScanbotSDK

class ActionBarConfigurationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Retrieve the instance of the action bar from the configuration object.
        let actionBar = configuration.actionBar
        
        // Show the flash button.
        actionBar.flashButton.visible = true
        
        // Configure the inactive state of the flash button.
        actionBar.flashButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flashButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the active state of the flash button.
        actionBar.flashButton.activeBackgroundColor = SBSDKUI2Color(colorString: "#FFCE5C")
        actionBar.flashButton.activeForegroundColor = SBSDKUI2Color(colorString: "#000000")
        
        // Show the zoom button.
        actionBar.zoomButton.visible = true
        
        // Configure the zoom button.
        actionBar.zoomButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.zoomButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Show the flip camera button.
        actionBar.flipCameraButton.visible = true
        
        // Configure the flip camera button.
        actionBar.flipCameraButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flipCameraButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Create and set an array of accepted barcode formats.
        configuration.recognizerConfiguration.barcodeFormats = SBSDKBarcodeFormats.twod
        
        // Present the view controller modally.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
