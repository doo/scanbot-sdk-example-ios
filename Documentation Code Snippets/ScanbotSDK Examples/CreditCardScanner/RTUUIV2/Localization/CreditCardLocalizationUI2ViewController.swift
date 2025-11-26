//
//  CreditCardLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardLocalizationUI2ViewController: UIViewController {
    
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
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
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
