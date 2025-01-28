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
        
        // Configure the finder example overlay. You can choose between the two-line and three-line preset.
        // Each example preset has a default text for each line, but you can change it accordingly to your liking.
        // Each preset has a fixed aspect ratio adjusted to it's number of lines. To override, please use 'aspectRatio'
        // parameter in 'viewFinder' field in the main configuration object.
        // For this example we will use the three-line preset.
        let mrzFinderLayoutPreset = SBSDKUI2ThreeLineMRZFinderLayoutPreset()
        mrzFinderLayoutPreset.mrzTextLine1 = "I<USA2342353464<<<<<<<<<<<<<<<"
        mrzFinderLayoutPreset.mrzTextLine2 = "9602300M2904076USA<<<<<<<<<<<2"
        mrzFinderLayoutPreset.mrzTextLine3 = "SMITH<<JACK<<<<<<<<<<<<<<<<<<<"
        
        // Set the configured finder layout preset on the main configuration object.
        configuration.mrzExampleOverlay = mrzFinderLayoutPreset
        
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
