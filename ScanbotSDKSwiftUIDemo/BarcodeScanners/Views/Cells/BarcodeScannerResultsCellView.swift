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
                .frame(width: barcode.barcodeImage.size.equalTo(.zero) ? 0 : 50,
                       height: barcode.barcodeImage.size.equalTo(.zero) ? 0 : 50)
            VStack(alignment: .leading) {
                Text(barcode.rawTextStringWithExtension)
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
                                                                         type: SBSDKBarcodeType.aztec,
                                                                         barcodeImage: UIImage(systemName: "sun.dust")!, 
                                                                         sourceImage: nil,
                                                                         rawTextString: "Some Different Text",
                                                                         rawBytes: Data(),
                                                                         metadata: [String: String]()))
    }
}
