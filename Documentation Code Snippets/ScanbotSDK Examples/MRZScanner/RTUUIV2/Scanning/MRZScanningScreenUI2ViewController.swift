//
//  MRZScanningUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 20.01.25.
//

import UIKit
import ScanbotSDK

class MRZScanningUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 5.0]
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
        
        // Configure the success overlay.
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep
        
        // Configure the vibration.
        configuration.vibration.enabled = false
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2MRZScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            
            // Cast the resulted generic document to the MRZ model using the `wrap` method.
            if let model = result.mrzDocument?.wrap() as? SBSDKDocumentsModelMRZ {
                
                // Retrieve the values.
                // e.g
                if let birthDate = model.birthDate?.value {
                    print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                }
                if let nationality = model.nationality?.value {
                    print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                }
            }
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning MRZ: \(error.localizedDescription)")
        }
    }
}
