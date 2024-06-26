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
    
    @State private var isCancelled: Bool = false
    @State private var scanError: Error? = nil
    @State private var result: SBSDKUI2BarcodeScannerResult? = nil

    var body: some View {
        
        SBSDKUI2BarcodeScannerView(configuration: SBSDKUI2BarcodeScannerConfiguration(),
                                   isShown: $isCancelled, 
                                   error: $scanError, 
                                   result: $result)
        .onDisappear() {
            if let result, !isCancelled {
                scanningResult = BarcodeScanningResult(barcodeScannerName: "SwiftUI Barcode Scanner", scannedItems: result.items)
            }
        }
        .onChange(of: isCancelled) { oldValue, newValue in
            
        }
    }
}
