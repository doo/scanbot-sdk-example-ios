//
//  CreditCardScannerRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI credit card scanner using the native SwiftUI component `SBSDKUI2CreditCardScannerView`.
struct CreditCardScannerRTUUIView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2CreditCardScannerView?
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
            scanner = try SBSDKUI2CreditCardScannerView(configuration: SBSDKUI2CreditCardScannerScreenConfiguration(), completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(result: SBSDKUI2CreditCardScannerUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: "Credit card", document: result.creditCard, extraFields: [ScanResultField(name: "Recognition status", value: "\(result.recognitionStatus.rawValue)")])) 
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
