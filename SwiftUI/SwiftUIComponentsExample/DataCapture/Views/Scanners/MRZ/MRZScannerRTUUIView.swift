//
//  MRZScannerRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI MRZ scanner using the native SwiftUI component `SBSDKUI2MRZScannerView`.
struct MRZScannerRTUUIView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2MRZScannerView?
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
            scanner = try SBSDKUI2MRZScannerView(configuration: SBSDKUI2MRZScannerScreenConfiguration(), completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(result: SBSDKUI2MRZScannerUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: "MRZ", document: result.mrzDocument, extraFields: [ScanResultField(name: "Raw MRZ", value: result.rawMRZ)])) 
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
