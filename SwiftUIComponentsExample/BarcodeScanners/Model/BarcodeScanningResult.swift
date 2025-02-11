//
//  BarcodeScanningResult.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 27.07.21.
//

import ScanbotSDK

struct BarcodeResult: Identifiable {
    let id = UUID()
    
    let type: SBSDKBarcodeFormat?
    let rawTextString: String
    let rawTextStringWithExtension: String
    let barcodeImage: UIImage
}

struct BarcodeScanningResult {
    let barcodeScannerName: String
    let scannedBarcodes: [BarcodeResult]
    
    init(barcodeScannerName: String = "", scannedItems: [SBSDKBarcodeItem] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedItems.map({ barcode in
            return BarcodeResult(type: barcode.format,
                                 rawTextString: barcode.text,
                                 rawTextStringWithExtension: barcode.displayText,
                                 barcodeImage: barcode.sourceImage?.toUIImage() ?? UIImage())
        })
    }
    
    init(barcodeScannerName: String = "", scannedResultItems: [SBSDKUI2BarcodeScannerUIItem] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedResultItems.map({ barcodeItem in
            return BarcodeResult(type: barcodeItem.barcode.format,
                                 rawTextString: barcodeItem.barcode.text,
                                 rawTextStringWithExtension: barcodeItem.barcode.displayText,
                                 barcodeImage: barcodeItem.barcode.sourceImage?.toUIImage() ?? UIImage())
        })
    }
}
