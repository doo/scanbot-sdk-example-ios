//
//  BarcodeScanResultDetailsView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 30.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScanResultDetailsView: View {
    
    private let scanResult: SBSDKBarcodeScannerResult
    
    init(scanResult: SBSDKBarcodeScannerResult) {
        self.scanResult = scanResult
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: scanResult.barcodeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(scanResult.type.name)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
                Text(scanResult.rawTextString)
                Spacer()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanResultDetailsView(scanResult: SBSDKBarcodeScannerResult(polygon: SBSDKPolygon(),
                                                                    type: SBSDKBarcodeTypeAztec,
                                                                    barcodeImage: UIImage(systemName: "sun.dust")!,
                                                                    rawTextString: "Test Test Test\nTest Test\nTest",
                                                                    rawBytes: Data()))
    }
}
