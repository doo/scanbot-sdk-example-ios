//
//  DocumentScannerClassicView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerClassicView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode

    @Binding var scanningResult: DocumentScanningResult
    @Binding var isScanningEnabled: Bool

    private let document = SBSDKDocument()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let scannerViewController = SBSDKDocumentScannerViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension DocumentScannerClassicView {
    final class Coordinator: NSObject, SBSDKDocumentScannerViewControllerDelegate {
        
        private let parent: DocumentScannerClassicView
                        
        init(_ parent: DocumentScannerClassicView) {
            self.parent = parent
        }
        
        func documentScannerViewControllerShouldScanDocument(_ controller: SBSDKDocumentScannerViewController) -> Bool {
            return parent.isScanningEnabled
        }
        
        func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController, didFailScanning error: any Error) {
            if parent.presentationMode.wrappedValue.isPresented {
                parent.scanningResult = DocumentScanningResult(error: error)
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                           didSnapDocumentImage documentImage: SBSDKImageRef,
                                           on originalImage: SBSDKImageRef,
                                           with result: SBSDKDocumentDetectionResult?, autoSnapped: Bool) {
            
            if parent.presentationMode.wrappedValue.isPresented {
                
                let documentPage = SBSDKDocumentPage(image: originalImage, polygon: result?.polygon, parametricFilters: .none)
                
                parent.document.add(documentPage)
                
                do {
                    let scannedDocument = try SBSDKScannedDocument(document: parent.document, documentImageSizeLimit: 0)
                    parent.scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
                } catch {
                    parent.scanningResult = DocumentScanningResult(error: error)
                }
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
