//
//  CreditCardActionBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardActionBarUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
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
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2CreditCardScannerViewController.present(on: self,
                                                                                   configuration: configuration)
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
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning credit card: \(error.localizedDescription)")
        }
    }
}
