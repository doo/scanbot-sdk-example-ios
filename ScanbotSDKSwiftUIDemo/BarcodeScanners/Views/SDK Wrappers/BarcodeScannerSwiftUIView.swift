//
//  BarcodeScannerSwiftUIView.swift
//  ScanbotSDKSwiftUIDemo
//
//  Created by Sebastian Husche on 21.05.24.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerSwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scanningResult: BarcodeScanningResult
    
    @State private var isShown: Bool = true
    @State private var scanError: Error? = nil
    @State private var result: SBSDKUI2BarcodeScannerResult? = nil

    var body: some View {
        if isShown {
            SBSDKUI2BarcodeScannerView(configuration: SBSDKUI2BarcodeScannerConfiguration()) { result in
                self.result = result
                isShown.toggle()
            } onCancel: { 
                
            } onError: { error in
                scanError = error
            }
            .onDisappear() {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                    if let result {
                        scanningResult = BarcodeScanningResult(barcodeScannerName: "SwiftUI Barcode Scanner", scannedItems: result.items)
                    }
                }
            }
        }
    }
}
