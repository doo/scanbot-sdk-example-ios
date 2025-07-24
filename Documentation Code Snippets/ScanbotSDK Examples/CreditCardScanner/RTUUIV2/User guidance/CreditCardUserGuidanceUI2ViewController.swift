//
//  CreditCardUserGuidanceUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardUserGuidanceUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
        // Configure user guidances
        
        // Top user guidance
        // Retrieve the instance of the top user guidance from the configuration object.
        let topUserGuidance = configuration.topUserGuidance
        // Show the user guidance.
        topUserGuidance.visible = true
        // Configure the title.
        topUserGuidance.title.text = "Scan your Credit Card"
        topUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
        // Scan status user guidance
        // Retrieve the instance of the user guidance from the configuration object.
        let scanStatusUserGuidance = configuration.scanStatusUserGuidance
        // Show the user guidance.
        scanStatusUserGuidance.visibility = true
        // Configure the title.
        scanStatusUserGuidance.title.text = "Scan credit card"
        scanStatusUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        scanStatusUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
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
