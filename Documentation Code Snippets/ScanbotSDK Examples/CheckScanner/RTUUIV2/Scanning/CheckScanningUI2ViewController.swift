//
//  CheckScanningUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class CheckScanningUI2ViewController: UIViewController {
    
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
        
        // Configure the timeout for the check scanner to wait for a check to be found.
        // If no check is found within this time, the warning alert will be shown.
        configuration.noCheckFoundTimeout = 1000
        // Configure the timeout for the scan process.
        // If the scan process takes longer than this value, the warning alert will be shown.
        configuration.accumulationTimeout = 500
        
        // Configure the success overlay.
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Set the timeout after which the overlay is dismissed.
        configuration.successOverlay.timeout = 100
        
        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 3.0]
        configuration.cameraConfiguration.flashEnabled = false
        configuration.cameraConfiguration.pinchToZoomEnabled = true
        
        // Configure the UI elements like icons or buttons.
        // e.g The top bar introduction button.
        configuration.topBarOpenIntroScreenButton.visible = true
        configuration.topBarOpenIntroScreenButton.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Cancel button.
        configuration.topBar.cancelButton.visible = true
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.topBar.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")
        
        // Configure the view finder.
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
        // Configure the action bar.
        configuration.actionBar.flashButton.visible = true
        configuration.actionBar.zoomButton.visible = true
        configuration.actionBar.flipCameraButton.visible = false
        
        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep
        
        // Configure the vibration.
        configuration.vibration.enabled = false
        
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
