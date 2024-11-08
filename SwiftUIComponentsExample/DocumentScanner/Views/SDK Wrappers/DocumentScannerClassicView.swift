//
//  DocumentScannerClassicView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerClassicView: UIViewControllerRepresentable {
    
    @Binding var scanningResult: DocumentScanningResult
    @Binding var isRecognitionEnabled: Bool
    
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
        
        func documentScannerViewControllerShouldDetectDocument(_ controller: SBSDKDocumentScannerViewController) -> Bool {
            return parent.isRecognitionEnabled
        }
        
        func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                           didSnapDocumentImage documentImage: UIImage,
                                           on originalImage: UIImage,
                                           with result: SBSDKDocumentDetectionResult?, autoSnapped: Bool) {
            
            let documentPage = SBSDKDocumentPage(image: originalImage, polygon: result?.polygon, filter: .none)
            parent.document.add(documentPage)
            
            guard let scannedDocument = SBSDKScannedDocument(document: parent.document, documentImageSizeLimit: 0)
            else { return }
            
            parent.scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
        }
    }
}
