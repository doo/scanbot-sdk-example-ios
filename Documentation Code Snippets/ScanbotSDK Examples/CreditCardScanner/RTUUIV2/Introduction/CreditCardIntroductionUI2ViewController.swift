//
//  CreditCardIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CreditCardIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true
        
        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan a credit card"
        
        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .creditCardNoImage()
        // For a custom image...
        configuration.introScreen.image = .creditCardIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default one sided image.
        configuration.introScreen.image = .creditCardIntroOneSideImage()
        // Or you can also use our default two sided image.
        configuration.introScreen.image = .creditCardIntroTwoSidesImage()
        
        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the text.
        configuration.introScreen.text.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.text.text = "To quickly and securely input your credit card details, please hold your device over the credit card, so that the camera aligns with the numbers on the front of the card.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your card details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin."
        
        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
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
