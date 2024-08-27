//
//  DocumentScannerRTUUIView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 27.08.24.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerRTUUIView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scanningResult: DocumentScanningResult
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> SBSDKUI2DocumentScannerController {
        
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        guard let scannerViewController = SBSDKUI2DocumentScannerController(configuration: configuration,
                                                                            completionHandler: handleResult(scannedDocument:)) 
        else {
            fatalError("Failed to create SBSDKUI2DocumentScannerView. The documentUuid does not exist.")
        }
        
        return scannerViewController
    }
    
    func handleResult(scannedDocument: SBSDKScannedDocument?) {
        
        guard let scannedDocument else { return }
        scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func updateUIViewController(_ uiViewController: SBSDKUI2DocumentScannerController, context: Context) { }
}

extension DocumentScannerRTUUIView {
    final class Coordinator: NSObject, UINavigationControllerDelegate {
        
        private var parent: DocumentScannerRTUUIView
        
        init(_ parent: DocumentScannerRTUUIView) {
            self.parent = parent
        }
    }
}
