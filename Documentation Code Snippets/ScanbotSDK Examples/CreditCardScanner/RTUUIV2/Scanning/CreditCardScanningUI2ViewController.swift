//
//  CreditCardScanningUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardScanningUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
        // Configure the timeout for the scan process. If the scan process takes longer than this value, the
        // incomplete result will be returned.
        configuration.scanIncompleteDataTimeout = 500
        
        // Configure the success overlay.
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Set the timeout after which the overlay is dismissed.
        configuration.successOverlay.timeout = 100
        
        // Configure the incomplete scan overlay.
        configuration.incompleteDataOverlay.message.text = "Incomplete scan"
        configuration.incompleteDataOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.incompleteDataOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Set the timeout after which the overlay is dismissed.
        configuration.incompleteDataOverlay.timeout = 100
        
        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 3.0]
        configuration.cameraConfiguration.flashEnabled = false
        configuration.cameraConfiguration.pinchToZoomEnabled = true
        
        // Configure the UI elements like icons or buttons.
        // e.g The top bar introduction button.
        configuration.topBarOpenIntroScreenButton.visible = true
        configuration.topBarOpenIntroScreenButton.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Cancel button.
        configuration.topBar.cancelButton.visible = true
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.topBar.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")
        
        // Configure the view finder.
        configuration.viewFinder.visible = true
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
        // Configure the action bar.
        configuration.actionBar.flashButton.visible = true
        configuration.actionBar.zoomButton.visible = true
        configuration.actionBar.flipCameraButton.visible = false
        
        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep
        
        // Configure the vibration.
        configuration.vibration.enabled = false
        
        // Present the view controller modally.
        SBSDKUI2CreditCardScannerViewController.present(on: self,
                                                        configuration: configuration) { result in
            
            if let result {
                // Handle the result.
                
                // Cast the resulted generic document to the credit card model using the `wrap` method.
                if let model = result.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {
                    
                    // Retrieve the values.
                    // e.g
                    if let cardNumber = model.cardNumber?.value {
                        print("Card number: \(cardNumber.text), Confidence: \(cardNumber.confidence)")
                    }
                    if let name = model.cardholderName?.value {
                        print("Name: \(name.text), Confidence: \(name.confidence)")
                    }
                }
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
