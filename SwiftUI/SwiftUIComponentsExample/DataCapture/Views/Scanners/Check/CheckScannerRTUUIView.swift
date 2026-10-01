//
//  CheckScannerRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI check scanner using the native SwiftUI component `SBSDKUI2CheckScannerView`.
struct CheckScannerRTUUIView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2CheckScannerView?
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
            scanner = try SBSDKUI2CheckScannerView(configuration: SBSDKUI2CheckScannerScreenConfiguration(),
                                                   completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(result: SBSDKUI2CheckScannerUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: "Check", document: result.check))
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
