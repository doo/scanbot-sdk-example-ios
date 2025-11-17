//
//  CheckActionBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CheckActionBarUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
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
        SBSDKUI2CheckScannerViewController.present(on: self,
                                                   configuration: configuration) { controller, result, error in
            if let error {
                
                // Handle the error.
                print("Error scanning check: \(error.localizedDescription)")
                
            } else if let result {
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
            }
        }
    }
}
