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
    @Binding var isRecognitionEnabled: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> SBSDKUIBarcodeScannerViewController {
        let acceptedTypes = SBSDKBarcodeType.allTypes()
        let configuration = SBSDKUIBarcodeScannerConfiguration.default()
        configuration.behaviorConfiguration.acceptedBarcodeTypes = acceptedTypes
        
        let scannerViewController = SBSDKUIBarcodeScannerViewController.createNew(with: configuration,
                                                                                   andDelegate: nil)
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: SBSDKUIBarcodeScannerViewController, context: Context) {
        uiViewController.isRecognitionEnabled = isRecognitionEnabled
    }
}

extension BarcodeScannerRTUUIView {
    final class Coordinator: NSObject, SBSDKUIBarcodeScannerViewControllerDelegate, UINavigationControllerDelegate {
        
        private var parent: BarcodeScannerRTUUIView
        
        init(_ parent: BarcodeScannerRTUUIView) {
            self.parent = parent
        }
        
        func qrBarcodeDetectionViewController(_ viewController: SBSDKUIBarcodeScannerViewController,
                                              didDetect barcodeResults: [SBSDKBarcodeScannerResult]) {
            if parent.presentationMode.wrappedValue.isPresented {
                parent.scanningResult = BarcodeScanningResult(barcodeScannerName: "RTU UI Barcode Scanner",
                                                       scannedBarcodes: barcodeResults)
                parent.presentationMode.wrappedValue.dismiss()
                parent.isRecognitionEnabled = false
            }
        }
        
        func qrBarcodeDetectionViewControllerDidCancel(_ viewController: SBSDKUIBarcodeScannerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
