//
//  BarcodeScanningResult.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 27.07.21.
//

import ScanbotSDK

struct BarcodeResult: Identifiable {
    let id = UUID()
    
    let type: SBSDKBarcodeType?
    let rawTextString: String
    let rawTextStringWithExtension: String
    let barcodeImage: UIImage
}

struct BarcodeScanningResult {
    let barcodeScannerName: String
    let scannedBarcodes: [BarcodeResult]
    
    init(barcodeScannerName: String = "", scannedBarcodes: [SBSDKBarcodeScannerResult] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedBarcodes.map({ barcode in
            return BarcodeResult(type: barcode.type,
                                 rawTextString: barcode.rawTextString,
                                 rawTextStringWithExtension: barcode.displayText,
                                 barcodeImage: barcode.barcodeImage)
        })
    }
    
    init(barcodeScannerName: String = "", scannedItems: [SBSDKUI2BarcodeItem] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedItems.map({ barcode in
            return BarcodeResult(type: barcode.type?.toBarcodeType(),
                                 rawTextString: barcode.text,
                                 rawTextStringWithExtension: barcode.displayText,
                                 barcodeImage: UIImage())
        })
    }
}
