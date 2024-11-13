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
    
    // Create an instance of `SBSDKBarcodeScanner`, passing the configuration.
    let scanner = SBSDKBarcodeScanner(configuration: configuration)
    
    // Returns the result after running the scanner on the image.
    let result = scanner.detectBarcodes(on: image)
}
