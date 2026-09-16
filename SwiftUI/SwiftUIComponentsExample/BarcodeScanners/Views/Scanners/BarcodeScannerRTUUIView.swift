//
//  BarcodeScannerRTUUIView.swift
//  BarcodeSDKSwiftUIShowcase
//
//  Created by Danil Voitenko on 19.07.21.
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI barcode scanner using the native SwiftUI component `SBSDKUI2BarcodeScannerView`.
struct BarcodeScannerRTUUIView: View {
    
    private static let scannerName = "RTU UI Barcode Scanner"
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var scanningResult: BarcodeScanningResult
    
    @State private var scanner: SBSDKUI2BarcodeScannerView?
    
    var body: some View {
        Group {
            if let scanner {
                scanner
            } else {
                Color.black
            }
        }
        .onAppear(perform: createScannerIfNeeded)
    }
    
    private func createScannerIfNeeded() {
        guard scanner == nil else { return }
        do {
            scanner = try SBSDKUI2BarcodeScannerView(configuration: configuration(), completion: handle)
        } catch {
            finish(with: nil, error: error)
        }
    }
    
    private func handle(result: SBSDKUI2BarcodeScannerUIResult?, error: Error?) {
        finish(with: result, error: error)
    }
    
    private func finish(with result: SBSDKUI2BarcodeScannerUIResult?, error: Error?) {
        if let result {
            scanningResult = BarcodeScanningResult(barcodeScannerName: Self.scannerName,
                                                   scannedResultItems: result.items)
        } else if let error {
            scanningResult = BarcodeScanningResult(barcodeScannerName: Self.scannerName, error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func configuration() -> SBSDKUI2BarcodeScannerScreenConfiguration {
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        configuration.scannerConfiguration.barcodeFormatConfigurations = [SBSDKBarcodeFormatCommonConfiguration()]
        return configuration
    }
}
