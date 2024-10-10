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
    
    // Types of barcodes you want to detect.
    let typesToDetect = SBSDKBarcodeType.allTypes
    
    // Creates an instance of `SBSDKBarcodeScanner`.
    let detector = SBSDKBarcodeScanner(types: typesToDetect)
    
    // Returns the result after running detector on the image.
    let result = detector.detectBarCodes(on: image)
}
