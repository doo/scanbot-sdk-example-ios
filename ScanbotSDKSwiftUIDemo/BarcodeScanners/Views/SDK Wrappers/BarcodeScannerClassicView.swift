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

    @Binding private var scanningResult: BarcodeScanningResult
    @Binding private var isRecognitionEnabled: Bool

    init(scanningResult: Binding<BarcodeScanningResult>,
         isRecognitionEnabled: Binding<Bool>) {
        _scanningResult = scanningResult
        _isRecognitionEnabled = isRecognitionEnabled
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let rootViewController = UIViewController()
        guard let viewController = SBSDKBarcodeScannerViewController(parentViewController: rootViewController,
                                                                     parentView: nil,
                                                                     delegate: context.coordinator) else {
            fatalError("Error occurred during SBSDKBarcodeScannerViewController Initialization")
        }
        let configuration = viewController.viewFinderConfiguration
        configuration.lineColor = UIColor.green
        configuration.lineWidth = 5
        configuration.aspectRatio = SBSDKAspectRatio(width: 1, andHeight: 0.5)
        configuration.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
        configuration.isViewFinderEnabled = true
        viewController.viewFinderConfiguration = configuration
                
        return rootViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension BarcodeScannerClassicView {
    final class Coordinator: NSObject, SBSDKBarcodeScannerViewControllerDelegate, UINavigationControllerDelegate {
        
        private let parent: BarcodeScannerClassicView
        
        init(_ parent: BarcodeScannerClassicView) {
            self.parent = parent
        }
        
        func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
            return self.parent.isRecognitionEnabled
        }
        
        func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                      didDetectBarcodes codes: [SBSDKBarcodeScannerResult],
                                      on image: UIImage) {
            if parent.presentationMode.wrappedValue.isPresented {
                self.parent.scanningResult = BarcodeScanningResult(barcodeScannerName: "Classic Barcode Scanner",
                                                            scannedBarcodes: codes)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

