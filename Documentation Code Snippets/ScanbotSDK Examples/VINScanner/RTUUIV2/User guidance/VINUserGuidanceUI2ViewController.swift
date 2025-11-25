//
//  VINUserGuidanceUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class VINUserGuidanceUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()
        
        // Configure user guidances
        
        // Top user guidance
        // Retrieve the instance of the top user guidance from the configuration object.
        let topUserGuidance = configuration.topUserGuidance
        // Show the user guidance.
        topUserGuidance.visible = true
        // Configure the title.
        topUserGuidance.title.text = "Locate the VIN you are looking for"
        topUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        topUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
        // Finder overlay user guidance
        // Retrieve the instance of the finder overlay user guidance from the configuration object.
        let finderUserGuidance = configuration.finderViewUserGuidance
        // Show the user guidance.
        finderUserGuidance.visible = true
        // Configure the title.
        finderUserGuidance.title.text = "Scanning for VIN..."
        finderUserGuidance.title.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Configure the background.
        finderUserGuidance.background.fillColor = SBSDKUI2Color(colorString: "#7A000000")
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2VINScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.textResult.rawText)
            print(result.textResult.confidence)
            print(result.textResult.validationSuccessful)
            
            // If expecting VIN from barcode.
            print(result.barcodeResult.extractedVIN)
            print(result.barcodeResult.status)
            print(result.barcodeResult.rectangle)
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning VIN: \(error.localizedDescription)")
        }
    }
}
