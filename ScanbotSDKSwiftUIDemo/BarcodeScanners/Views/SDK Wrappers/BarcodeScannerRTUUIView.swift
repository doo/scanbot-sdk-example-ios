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
    
    @Binding private var scanningResult: BarcodeScanningResult
    @Binding private var isRecognitionEnabled: Bool
    
    private let scannerViewController: SBSDKUIBarcodeScannerViewController
    
    init(scanningResult: Binding<BarcodeScanningResult>,
         isRecognitionEnabled: Binding<Bool>) {
        _scanningResult = scanningResult
        _isRecognitionEnabled = isRecognitionEnabled
        
        let acceptedTypes = SBSDKBarcodeType.allTypes()
        let configuration = SBSDKUIBarcodeScannerConfiguration.default()
        configuration.behaviorConfiguration.acceptedMachineCodeTypes = acceptedTypes
        
        self.scannerViewController = SBSDKUIBarcodeScannerViewController.createNew(with: configuration,
                                                                                   andDelegate: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> SBSDKUIBarcodeScannerViewController {
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: SBSDKUIBarcodeScannerViewController, context: Context) {
        scannerViewController.isRecognitionEnabled = self.isRecognitionEnabled
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
                parent.scannerViewController.isRecognitionEnabled = false
                parent.isRecognitionEnabled = false
            }
        }
        
        func qrBarcodeDetectionViewControllerDidCancel(_ viewController: SBSDKUIBarcodeScannerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
