//
//  CheckCustomConfigurationUI2ViewController.swift
//  ScanbotSDK Examples
//

import UIKit
import ScanbotSDK

class CheckCustomConfigurationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // An instance of `SBSDKUI2CheckScannerScreenConfiguration` which contains the configuration settings for the check scanner.
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
        do {
            let scannedCheck = try await SBSDKUI2CheckScannerViewController.present(on: self, configuration: configuration)
            
            // Process and show the scanned check here.
            
            // Cast the resulting generic document to the appropriate check model using the `wrap` method.
            if let genericDocument = scannedCheck.check, let wrapper = genericDocument.wrap() {
                
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
                } else if wrapper is SBSDKCheckDocumentModelUnknownCheck {
                    
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
            } else {
                print("No document found.")
            }
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Show error view here.
            print("Scan error: \(error.localizedDescription)")
        }
    }
}
