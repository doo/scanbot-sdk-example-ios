//
//  BarcodePaletteUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 08.01.24.
//

import Foundation
import ScanbotSDK

class BarcodePaletteUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Retrieve the instance of the palette from the configuration object.
        let palette = configuration.palette
        
        // Configure the colors.
        // The palette already has the default colors set, so you only need to modify the colors you want to change.
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
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2BarcodeScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            result.items.forEach { barcodeItem in
                // e.g
                print(barcodeItem.count)
                print(barcodeItem.barcode.format.name)
                print(barcodeItem.barcode.text)
                print(barcodeItem.barcode.textWithExtension)
                // Check out other available properties in `SBSDKBarcodeItem`.
            }
            print(result.selectedZoomFactor)
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning barcode: \(error.localizedDescription)")
        }
    }
}
