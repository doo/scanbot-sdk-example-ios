//
//  CheckFinderOverlayUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 10.02.25.
//

import UIKit
import ScanbotSDK

class CheckFinderOverlayUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
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
