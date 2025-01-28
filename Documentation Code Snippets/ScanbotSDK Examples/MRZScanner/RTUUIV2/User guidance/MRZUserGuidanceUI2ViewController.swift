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
        startScanning()
    }
    
    func startScanning() {
        
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
        SBSDKUI2MRZScannerViewController.present(on: self,
                                                 configuration: configuration) { result in
            if let result {
                // Handle the result.
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
