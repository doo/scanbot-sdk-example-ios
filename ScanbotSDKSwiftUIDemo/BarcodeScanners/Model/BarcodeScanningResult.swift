//
//  BarcodeScanningResult.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 27.07.21.
//

import ScanbotSDK

struct BarcodeScanningResult {
    let barcodeScannerName: String
    let scannedBarcodes: [SBSDKBarcodeScannerResult]
    
    init(barcodeScannerName: String = "", scannedBarcodes: [SBSDKBarcodeScannerResult] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedBarcodes
    }
}
