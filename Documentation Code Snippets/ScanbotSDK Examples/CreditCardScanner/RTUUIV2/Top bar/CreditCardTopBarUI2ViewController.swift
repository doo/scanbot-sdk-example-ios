//
//  CreditCardTopBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardTopBarUI2ViewController: UIViewController {
    
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
        
        // Set the top bar mode.
        configuration.topBar.mode = .gradient
        
        // Set the background color which will be used as a gradient.
        configuration.topBar.backgroundColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Set the status bar mode.
        configuration.topBar.statusBarMode = .light
        
        // Configure the cancel button.
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
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
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning credit card: \(error.localizedDescription)")
        }
    }
}
