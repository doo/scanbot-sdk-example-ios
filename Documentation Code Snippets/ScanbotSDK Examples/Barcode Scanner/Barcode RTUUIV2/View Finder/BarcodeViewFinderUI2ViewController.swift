//
//  BarcodeViewFinderUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 15.07.25.
//

import Foundation
import ScanbotSDK

class BarcodeViewFinderUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Set visibility for the view finder.
        configuration.viewFinder.visible = true
        
        // Create the instance of the style, either `SBSDKUI2FinderCorneredStyle` or `SBSDKUI2FinderStrokedStyle`.
        let style = SBSDKUI2FinderCorneredStyle(strokeColor: SBSDKUI2Color(colorString: "#FFFFFFFF"),
                                                strokeWidth: 3.0,
                                                cornerRadius: 10.0)
        
        // Set the configured style.
        configuration.viewFinder.style = style
        
        // Set the desired aspect ratio of the view finder.
        configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 1.0, height: 1.0)
        
        // Set the overlay color.
        configuration.viewFinder.overlayColor = SBSDKUI2Color(colorString: "#26000000")
        
        // Create and set an array of accepted barcode formats.
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
        // Present the view controller modally.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
