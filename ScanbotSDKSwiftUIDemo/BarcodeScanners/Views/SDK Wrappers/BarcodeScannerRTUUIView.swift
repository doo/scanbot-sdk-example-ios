//
//  BarcodeScannerRTUUIView.swift
//  BarcodeSDKSwiftUIShowcase
//
//  Created by Danil Voitenko on 19.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerRTUUIView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scanningResult: BarcodeScanningResult
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> SBSDKUI2BarcodeScannerViewController {
        
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        let acceptedTypes = SBSDKBarcodeType.allTypes
        configuration.recognizerConfiguration.barcodeTypes = acceptedTypes
        
        let scannerViewController = SBSDKUI2BarcodeScannerViewController.create(with: configuration,
                                                                                handler: { controller, cancelled, error, result in
            
            if let barcodeResults = result?.items,
               presentationMode.wrappedValue.isPresented {
                scanningResult = BarcodeScanningResult(barcodeScannerName: "RTU UI Barcode Scanner",
                                                       scannedItems: barcodeResults)
                presentationMode.wrappedValue.dismiss()
                
            } else if cancelled {
                
                presentationMode.wrappedValue.dismiss()
            }
        })
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: SBSDKUI2BarcodeScannerViewController, context: Context) { }
}

extension BarcodeScannerRTUUIView {
    final class Coordinator: NSObject, UINavigationControllerDelegate {
        
        private var parent: BarcodeScannerRTUUIView
        
        init(_ parent: BarcodeScannerRTUUIView) {
            self.parent = parent
        }
    }
}
