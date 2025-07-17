//
//  CheckIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CheckIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true
        
        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan a check"
        
        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .checkNoImage()
        // For a custom image...
        configuration.introScreen.image = .checkIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default image.
        configuration.introScreen.image = .checkIntroDefaultImage()
        
        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the text.
        configuration.introScreen.explanation.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.explanation.text = "To quickly and securely scan your check details, please hold your device over the check, so that the camera aligns with all the information on the check.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your check details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin."
        
        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Present the view controller modally.
        SBSDKUI2CheckScannerViewController.present(on: self,
                                                   configuration: configuration) { result in
            if let result {
                // Handle the result.
                
                // Cast the resulted generic document to the appropriate check model using the `wrap` method.
                if let genericDocument = result.check, let wrapper = genericDocument.wrap() {
                    // Select the appropriate check type based on the wrapper instance
                    if let usaCheck = wrapper as? SBSDKCheckDocumentModelUSACheck {
                        // Retrieve values from the USA Check
                        if let accountNumber = usaCheck.accountNumber?.value {
                            print("Account number: \(accountNumber.text), Confidence: \(accountNumber.confidence)")
                        }
                        if let transitNumber = usaCheck.transitNumber?.value {
                            print("Transit number: \(transitNumber.text), Confidence: \(transitNumber.confidence)")
                        }
                        if let auxiliaryOnUs = usaCheck.auxiliaryOnUs?.value {
                            print("Auxiliary On-Us: \(auxiliaryOnUs.text), Confidence: \(auxiliaryOnUs.confidence)")
                        }
                    } else if let unknownCheck = wrapper as? SBSDKCheckDocumentModelUnknownCheck {
                        // Handle unknown check format
                        print("Unknown check format detected")
                        // Access available fields from the unknown check format
                        if let fields = genericDocument.allFields(includeEmptyFields: false) {
                            for field in fields {
                                if let value = field.value {
                                    print("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                                }
                            }
                        }
                    }
                    // Other check types can be added as needed (AUS, FRA, IND, ISR, KWT, etc.)
                }
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
