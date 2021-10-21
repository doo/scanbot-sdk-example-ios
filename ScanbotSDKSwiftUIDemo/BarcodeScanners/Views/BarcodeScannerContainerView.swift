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
    @State private var isRecognitionEnabled = true
    
    init(scanner: BarcodeScanner, scanningResult: Binding<BarcodeScanningResult>) {
        self.scanner = scanner
        _scanningResult = scanningResult
    }

    var body: some View {
        viewForScanner(scanner)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Text(scanner.title))
            .ignoresSafeArea()
            .onAppear{ self.isRecognitionEnabled = true }
            .onDisappear { self.isRecognitionEnabled = false }
    }
    
    private func viewForScanner(_ scanner: BarcodeScanner) -> some View {
        Group {
            switch scanner {
            case .rtuUI:
                BarcodeScannerRTUUIView(scanningResult: $scanningResult,
                                        isRecognitionEnabled: $isRecognitionEnabled)
            case .classic:
                BarcodeScannerClassicView(scanningResult: $scanningResult,
                                          isRecognitionEnabled: $isRecognitionEnabled)
            case .manuallyComposed:
                BarcodeScannerManuallyComposedView(scanningResult: $scanningResult)
            }
        }
    }
}

struct ScannerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerContainerView(scanner: .rtuUI, scanningResult: .constant(BarcodeScanningResult()))
    }
}
