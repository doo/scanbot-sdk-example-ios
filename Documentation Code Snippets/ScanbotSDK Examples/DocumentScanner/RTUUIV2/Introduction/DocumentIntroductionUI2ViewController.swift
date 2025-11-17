//
//  DocumentIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 05.08.24.
//

import Foundation
import ScanbotSDK

class DocumentIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the instance of the introduction configuration from the main configuration object.
        let introductionConfiguration = configuration.screens.camera.introduction
        
        // Show the introduction screen automatically when the screen appears.
        introductionConfiguration.showAutomatically = true
        
        // Create a new introduction item.
        let firstExampleEntry = SBSDKUI2IntroListEntry()
        
        // Configure the introduction image to be shown.
        firstExampleEntry.image = .receiptsIntroImage()
        
        // Configure the text.
        firstExampleEntry.text = SBSDKUI2StyledText(text: "Some text explaining how to scan a receipt",
                                                    color: SBSDKUI2Color(colorString: "#000000"))
        
        // Create a second introduction item.
        let secondExampleEntry = SBSDKUI2IntroListEntry()
        
        // Configure the introduction image to be shown.
        secondExampleEntry.image = .checkIntroImage()
        
        // Configure the text.
        secondExampleEntry.text = SBSDKUI2StyledText(text: "Some text explaining how to scan a check",
                                                     color: SBSDKUI2Color(colorString: "#000000"))
        
        // Set the items into the configuration.
        introductionConfiguration.items = [firstExampleEntry, secondExampleEntry]
        
        // Set the screen title.
        introductionConfiguration.title = SBSDKUI2StyledText(text: "Introduction",
                                                             color: SBSDKUI2Color(colorString: "#000000"))
        
        // Apply the introduction configuration.
        configuration.screens.camera.introduction = introductionConfiguration
        
        // Present the view controller modally.
        do {
            let controller = try SBSDKUI2DocumentScannerController.present(on: self,
                                                                           configuration: configuration)
            { controller, document, error in
                
                // Completion handler to process the result.
                
                if let document {
                    // Handle the document.
                    
                } else if let error {
                    
                    // Handle the error.
                    print("Error scanning document: \(error.localizedDescription)")
                }
            }
        }
        catch {
            print("Error while presenting the document scanner: \(error.localizedDescription)")
        }
    }
}
