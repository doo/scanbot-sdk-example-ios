//
//  MRZUserGuidanceUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 22.01.25.
//

import UIKit
import ScanbotSDK

class MRZUserGuidanceUI2ViewController: UIViewController {
    
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
        
        // Configure user guidances
        
        // Top user guidance
        // Retrieve the instance of the top user guidance from the configuration object.
        let topUserGuidance = configuration.topUserGuidance
        // Show the user guidance.
        topUserGuidance.visible = true
        // Configure the title.
        topUserGuidance.title.text = "Scan your Identity Document"
        topUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
        // Finder overlay user guidance
        // Retrieve the instance of the finder overlay user guidance from the configuration object.
        let finderUserGuidance = configuration.finderViewUserGuidance
        // Show the user guidance.
        finderUserGuidance.visible = true
        // Configure the title.
        finderUserGuidance.title.text = "Scan the MRZ"
        finderUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        finderUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
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
