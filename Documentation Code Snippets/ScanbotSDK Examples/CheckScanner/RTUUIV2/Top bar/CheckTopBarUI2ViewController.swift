//
//  CheckTopBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CheckTopBarUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
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
            let result = try await SBSDKUI2CheckScannerViewController.present(on: self, configuration: configuration)
            
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
                    // Other check types can be added as needed (AUS, FRA, IND, ISR, KWT, etc.)
                }
            }
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning Check: \(error.localizedDescription)")
        }
    }
}
