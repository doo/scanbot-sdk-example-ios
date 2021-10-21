//
//  ScannerResultsCellView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 27.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerResultsCellView: View {

    var barcode: SBSDKBarcodeScannerResult

    var body: some View {
        HStack {
            Image(uiImage: barcode.barcodeImage)
                .resizable()
                .scaledToFit()
                .padding(8)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(barcode.rawTextString)
                    .lineLimit(2)
                Text(barcode.type.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ScannerResultsView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerResultsCellView(barcode: SBSDKBarcodeScannerResult(polygon: SBSDKPolygon(),
                                                                type: SBSDKBarcodeTypeAztec,
                                                                barcodeImage: UIImage(systemName: "sun.dust")!,
                                                                rawTextString: "Some Different Text", rawBytes: Data()))
    }
}
