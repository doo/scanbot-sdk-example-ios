//
//  BarcodeDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func detectBarcodesOnImage() {
    
    // The image containing a barcode.
    guard let image = UIImage(named: "barcodeImage") else { return }
    
    // The barcode formats to be scanned.
    let formatsToDetect = SBSDKBarcodeFormats.all
    
    // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`, passing the desired barcode formats.
    let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
    
    // Create an instance of `SBSDKBarcodeScannerConfiguration`, passing the format configurations.
    let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
    
    // Enable the barcode image extraction.
    configuration.returnBarcodeImage = true
    
    do {
        
        // Create an instance of barcode scanner, passing the configuration.
        let scanner = try SBSDKBarcodeScanner(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run the scanner on the image.
        let result = try scanner.run(image: imageRef)
        
        for barcodeItem in result.barcodes {
            
            // Get the source image.
            let sourceImage = try barcodeItem.sourceImage?.toUIImage()
        }
    }
    catch {
        print("Error detecting barcode: \(error.localizedDescription)")
    }
}
