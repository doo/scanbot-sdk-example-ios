//
//  TextPatternIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class TextPatternIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()
        
        // Show the introduction screen automatically when the screen appears.
        configuration.introScreen.showAutomatically = true
        
        // Configure the background color of the screen.
        configuration.introScreen.backgroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the title for the intro screen.
        configuration.introScreen.title.text = "How to scan text"
        
        // Configure the image for the introduction screen.
        // If you want to have no image...
        configuration.introScreen.image = .textPatternIntroNoImage()
        // For a custom image...
        configuration.introScreen.image = .textPatternIntroCustomImage(uri: "PathToImage")
        // Or you can also use one of our default images.
        // e.g the meter device image.
        configuration.introScreen.image = .textPatternIntroMeterDevice()
        // shipping container image.
        configuration.introScreen.image = .textPatternIntroShippingContainer()
        // general text field image.
        configuration.introScreen.image = .textPatternIntroGeneralField()
        // alphabetic text field image.
        configuration.introScreen.image = .textPatternIntroAlphabeticField()
        
        // Configure the color of the handler on top.
        configuration.introScreen.handlerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the color of the divider.
        configuration.introScreen.dividerColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // Configure the text.
        configuration.introScreen.text.color = SBSDKUI2Color(colorString: "#000000")
        configuration.introScreen.text.text = "To scan a single line of text, please hold your device so that the camera viewfinder clearly captures the text you want to scan. Please ensure the text is properly aligned. Once the scan is complete, the text will be automatically extracted.\n\nPress 'Start Scanning' to begin."
        
        // Configure the done button.
        // e.g the text or the background color.
        configuration.introScreen.doneButton.text = "Start Scanning"
        configuration.introScreen.doneButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Present the view controller modally.
        SBSDKUI2TextPatternScannerViewController.present(on: self,
                                                         configuration: configuration) { result in
            if let result {
                // Handle the result.
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
