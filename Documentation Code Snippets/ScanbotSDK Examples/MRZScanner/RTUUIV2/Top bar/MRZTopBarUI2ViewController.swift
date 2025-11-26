//
//  MRZTopBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 22.01.25.
//

import UIKit
import ScanbotSDK

class MRZTopBarUI2ViewController: UIViewController {
    
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
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning MRZ: \(error.localizedDescription)")
        }
    }
}
