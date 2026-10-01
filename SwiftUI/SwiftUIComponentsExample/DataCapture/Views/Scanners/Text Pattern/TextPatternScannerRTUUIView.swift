//
//  TextPatternScannerRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI text pattern scanner using the native SwiftUI component `SBSDKUI2TextPatternScannerView`.
struct TextPatternScannerRTUUIView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2TextPatternScannerView?
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
            scanner = try SBSDKUI2TextPatternScannerView(configuration: SBSDKUI2TextPatternScannerScreenConfiguration(), completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(result: SBSDKUI2TextPatternScannerUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: "Text pattern", fields: [ScanResultField(name: "Text", value: result.rawText)])) 
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
