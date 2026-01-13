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
        do {
            let scannerViewController = try SBSDKUI2DocumentScannerController(configuration: configuration,
                                                                              completion: { _, scannedDocument, error in
                handleResult(scannedDocument: scannedDocument, error: error)
            })
            return scannerViewController
        } catch {
            fatalError("Failed to create SBSDKUI2DocumentScannerController: \(error)")
        }
    }
    
    func handleResult(scannedDocument: SBSDKScannedDocument?, error: Error?) {
        
        if let scannedDocument {
            scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
        } else if let error {
            scanningResult = DocumentScanningResult(error: error)
        }
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
