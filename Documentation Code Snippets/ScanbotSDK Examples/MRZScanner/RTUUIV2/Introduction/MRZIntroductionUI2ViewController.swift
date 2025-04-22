//
//  MRZIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 20.01.25.
//

import UIKit
import ScanbotSDK

class MRZIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true
        
        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan an MRZ"
        
        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .mrzIntroNoImage()
        // For a custom image...
        configuration.introScreen.image = .mrzIntroCustomImage(uri: "PathToImage")
        // Or you can also use our default image.
        configuration.introScreen.image = .mrzIntroDefaultImage()
        
        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the text.
        configuration.introScreen.explanation.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.explanation.text = "The Machine Readable Zone (MRZ) is a special code on your ID document (such as a passport or ID card) that contains your personal information in a machine-readable format.\n\nTo scan it, simply hold your camera over the document, so that it aligns with the MRZ section. Once scanned, the data will be automatically processed, and you will be directed to the results screen.\n\nPress 'Start Scanning' to begin."
        
        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Present the view controller modally.
        SBSDKUI2MRZScannerViewController.present(on: self,
                                                 configuration: configuration) { result in
            if let result {
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
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
