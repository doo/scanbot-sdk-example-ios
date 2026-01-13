//
//  CreditCardFinderOverlayUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 10.02.25.
//

import UIKit
import ScanbotSDK

class CreditCardFinderOverlayUI2ViewController: UIViewController {
    
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
        
        // Set the example overlay visibility.
        configuration.exampleOverlayVisible = true
        
        // Configure the view finder.
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
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
