//
//  BarcodeDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func detectBarcodesOnImage() {
    
    // Image containing barcode.
    guard let image = UIImage(named: "barcodeImage") else { return }
    
    // Barcode formats you want to detect.
    let formatsToDetect = SBSDKBarcodeFormats.all
    
    // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
    let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
    
    // Create an instance of `SBSDKBarcodeScannerConfiguration`.
    let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
    
    // Create an instance of `SBSDKBarcodeScanner`.
    let detector = SBSDKBarcodeScanner(configuration: configuration)
    
    // Returns the result after running detector on the image.
    let result = detector.detectBarcodes(on: image)
}
