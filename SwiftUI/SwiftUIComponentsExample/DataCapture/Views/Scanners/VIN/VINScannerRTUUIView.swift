//
//  VINScannerRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI VIN scanner using the native SwiftUI component `SBSDKUI2VINScannerView`.
struct VINScannerRTUUIView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2VINScannerView?
    @StateObject private var state = ScannerSessionState()
    
    var body: some View {
        Group {
            if let scanner {
                scanner
            } else {
                Color.black
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: createScannerIfNeeded)
        .scannerSession(state)
    }
    
    private func createScannerIfNeeded() {
        guard scanner == nil else { return }
        do {
            scanner = try SBSDKUI2VINScannerView(configuration: SBSDKUI2VINScannerScreenConfiguration(), completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(result: SBSDKUI2VINScannerUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: "VIN", fields: [ScanResultField(name: "Text", value: result.textResult.rawText), ScanResultField(name: "Barcode", value: result.barcodeResult.extractedVIN)])) 
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
