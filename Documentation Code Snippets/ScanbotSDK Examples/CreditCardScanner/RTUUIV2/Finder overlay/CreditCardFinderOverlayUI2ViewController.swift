//
//  CreditCardFinderOverlayUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 10.02.25.
//

import UIKit
import ScanbotSDK

class CreditCardFinderOverlayUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
        // Set the example overlay visibility.
        configuration.exampleOverlayVisible = true
        
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
        SBSDKUI2CreditCardScannerViewController.present(on: self,
                                                        configuration: configuration) { controller, result, error in
            
            if let result {
                // Handle the result.
                
            } else if let error {
                
                // Handle the error.
                print("Error scanning credit card: \(error.localizedDescription)")
            }
        }
    }
}
