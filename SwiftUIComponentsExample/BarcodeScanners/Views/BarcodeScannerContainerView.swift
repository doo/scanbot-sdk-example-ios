//
//  BarcodeScannerContainerView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 20.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerContainerView: View {

    private let scanner: BarcodeScanner

    @Binding private var scanningResult: BarcodeScanningResult
    @State private var isScanningEnabled = true
    @State private var selectedBarcode: SBSDKBarcodeItem? = nil
    
    init(scanner: BarcodeScanner, scanningResult: Binding<BarcodeScanningResult>) {
        self.scanner = scanner
        _scanningResult = scanningResult
    }

    var body: some View {
        viewForScanner(scanner)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Text(scanner.title))
            .onAppear { self.isScanningEnabled = true }
            .onDisappear { self.isScanningEnabled = false }
    }
    
    @ViewBuilder
    private func viewForScanner(_ scanner: BarcodeScanner) -> some View {
        Group {
            switch scanner {
            case .rtuUI:
                BarcodeScannerRTUUIView(scanningResult: $scanningResult)
            case .classic:
                BarcodeScannerClassicView(scanningResult: $scanningResult,
                                          isScanningEnabled: $isScanningEnabled,
                                          selectedBarcode: $selectedBarcode)
            case .swiftUI:
                BarcodeScannerSwiftUIView(scanningResult: $scanningResult)
            }
        }
    }
}

struct BarcodeScannerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerContainerView(scanner: .rtuUI, 
                                    scanningResult: .constant(BarcodeScanningResult(scannedItems: [])))
    }
}
