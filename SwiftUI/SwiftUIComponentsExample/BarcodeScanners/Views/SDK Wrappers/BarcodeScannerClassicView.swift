//
//  BarcodeScannerClassicView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 20.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerClassicView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scanningResult: BarcodeScanningResult
    @Binding var isScanningEnabled: Bool
    @Binding var selectedBarcode: SBSDKBarcodeItem?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let scannerViewController = SBSDKBarcodeScannerViewController()
        scannerViewController.delegate = context.coordinator
        
        let configuration = scannerViewController.viewFinderConfiguration
        configuration.lineColor = UIColor.green
        configuration.lineWidth = 5
        configuration.aspectRatio = SBSDKAspectRatio(width: 1, height: 0.5)
        configuration.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
        configuration.isViewFinderEnabled = true
        scannerViewController.viewFinderConfiguration = configuration
        
        let barcodeConfiguration = scannerViewController.copyCurrentConfiguration()
        barcodeConfiguration.returnBarcodeImage = true
        scannerViewController.setConfiguration(barcodeConfiguration)
        
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension BarcodeScannerClassicView {
    final class Coordinator: NSObject, SBSDKBarcodeScannerViewControllerDelegate, UINavigationControllerDelegate {
        
        private let parent: BarcodeScannerClassicView
        
        init(_ parent: BarcodeScannerClassicView) {
            self.parent = parent
        }
        
        func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController, didFailScanning error: any Error) {
            if parent.presentationMode.wrappedValue.isPresented {
                self.parent.scanningResult = BarcodeScanningResult(barcodeScannerName: "Classic Barcode Scanner",
                                                                   error: error)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func barcodeScannerControllerShouldScanBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
            return self.parent.isScanningEnabled
        }
        
        func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                      didScanBarcodes codes: [SBSDKBarcodeItem]) {
            if parent.presentationMode.wrappedValue.isPresented {
                self.parent.scanningResult = BarcodeScanningResult(barcodeScannerName: "Classic Barcode Scanner",
                                                                   scannedItems: codes)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

