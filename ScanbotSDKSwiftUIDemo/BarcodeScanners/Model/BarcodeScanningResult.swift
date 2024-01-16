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
    
    init(barcodeScannerName: String = "", scannedItems: [SBSDKUI2BarcodeItem] = []) {
        self.barcodeScannerName = barcodeScannerName
        self.scannedBarcodes = scannedItems.map({ scannedItem in
            return SBSDKBarcodeScannerResult(polygon: SBSDKPolygon(),
                                             type: scannedItem.type.toBarcodeType(),
                                             barcodeImage: UIImage(),
                                             sourceImage: nil, 
                                             rawTextString: scannedItem.text,
                                             rawBytes: Data(),
                                             metadata: [String: String]())
        })
    }
}
