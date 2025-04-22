//
//  BarcodeScanResultDetailsView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 30.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScanResultDetailsView: View {
    
    private let scanResult: BarcodeResult
    
    init(scanResult: BarcodeResult) {
        self.scanResult = scanResult
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: scanResult.barcodeImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: scanResult.barcodeImage.size.equalTo(.zero) ? 0 : 100,
                           height: scanResult.barcodeImage.size.equalTo(.zero) ? 0 : 100)
                Text(scanResult.type?.name ?? "")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
                Text(scanResult.rawTextStringWithExtension)
                Spacer()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScanResultDetailsView(scanResult: BarcodeResult(type: SBSDKBarcodeFormat.aztec,
                                                               rawTextString: "Test Test Test\nTest Test\nTest",
                                                               rawTextStringWithExtension: "",
                                                               barcodeImage: UIImage(systemName: "sun.dust")!))
    }
}
