//
//  PaletteUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 08.01.24.
//

import Foundation
import ScanbotSDK

class PaletteUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Retrieve the instance of the palette from the configuration object.
        let palette = configuration.palette
        
        // Configure the colors.
        // The palette already has the default colors set, so you don't have to always set all the colors.
        palette.sbColorPrimary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorPrimaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorNegative = SBSDKUI2Color(colorString: "#FF3737")
        palette.sbColorPositive = SBSDKUI2Color(colorString: "#4EFFB4")
        palette.sbColorWarning = SBSDKUI2Color(colorString: "#FFCE5C")
        palette.sbColorSecondary = SBSDKUI2Color(colorString: "#FFEDEE")
        palette.sbColorSecondaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorOnPrimary = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOnSecondary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorSurface = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOutline = SBSDKUI2Color(colorString: "#EFEFEF")
        palette.sbColorOnSurfaceVariant = SBSDKUI2Color(colorString: "#707070")
        palette.sbColorOnSurface = SBSDKUI2Color(colorString: "#000000")
        palette.sbColorSurfaceLow = SBSDKUI2Color(colorString: "#26000000")
        palette.sbColorSurfaceHigh = SBSDKUI2Color(colorString: "#7A000000")
        palette.sbColorModalOverlay = SBSDKUI2Color(colorString: "#A3000000")
        
        // Set the palette in the barcode scanner configuration object.
        configuration.palette = palette
        
        // Create and set an array of accepted barcode formats.
        configuration.recognizerConfiguration.barcodeFormats = SBSDKUI2BarcodeFormat.twoDFormats
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
