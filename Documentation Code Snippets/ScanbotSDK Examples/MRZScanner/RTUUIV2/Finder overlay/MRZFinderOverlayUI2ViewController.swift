//
//  MRZFinderOverlayUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 22.01.25.
//

import UIKit
import ScanbotSDK

class MRZFinderOverlayUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        // To hide the example layout preset.
        configuration.mrzExampleOverlay = .noLayoutPreset()
        
        // Configure the finder example overlay. You can choose between the two-line and three-line preset.
        // Each example preset has a default text for each line, but you can change it according to your liking.
        // Each preset has a fixed aspect ratio adjusted to its number of lines. To override, please use 'aspectRatio'
        // parameter in 'viewFinder' field in the main configuration object.
        
        // To use the default ones.
        configuration.mrzExampleOverlay = .twoLineMrzFinderLayoutPreset()
        configuration.mrzExampleOverlay = .threeLineMrzFinderLayoutPreset()
        
        // Or configure the preset.
        // For this example we will configure the three-line preset.
        let mrzFinderLayoutPreset = SBSDKUI2ThreeLineMRZFinderLayoutPreset()
        mrzFinderLayoutPreset.mrzTextLine1 = "I<USA2342353464<<<<<<<<<<<<<<<"
        mrzFinderLayoutPreset.mrzTextLine2 = "9602300M2904076USA<<<<<<<<<<<2"
        mrzFinderLayoutPreset.mrzTextLine3 = "SMITH<<JACK<<<<<<<<<<<<<<<<<<<"
        
        // Set the configured finder layout preset on the main configuration object.
        configuration.mrzExampleOverlay = mrzFinderLayoutPreset
        
        // Configure the view finder.
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
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
