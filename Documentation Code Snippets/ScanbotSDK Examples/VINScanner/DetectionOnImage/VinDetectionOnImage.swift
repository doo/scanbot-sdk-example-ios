//
//  VinDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

import Foundation
import ScanbotSDK
    
func scanVinOnImage() {
    
    // The image containing a vehicle identification number.
    guard let image = UIImage(named: "vinImage") else { return }
    
    // Create an instance of the configuration for vehicle identification numbers.
    let configuration = SBSDKVINScannerConfiguration()
    
    // Enable extraction of VIN from barcode.
    configuration.extractVINFromBarcode = true
    
    // Create an instance of `SBSDKVINScanner` using the configuration created above.
    let scanner = SBSDKVINScanner(configuration: configuration)
    
    // Run the scanner on the image.
    guard let result = scanner.scan(from: image) else { return }
    
    
    // If `extractVINFromBarcode` from the configuration is set to `True`, you must check the barcode result first.
    if result.barcodeResult.status == .success && !result.barcodeResult.extractedVIN.isEmpty {
        print(result.barcodeResult.extractedVIN)
        
    // else check the text result.
    } else if result.textResult.validationSuccessful && !result.textResult.rawText.isEmpty {
        print(result.textResult.rawText)
    }
}
