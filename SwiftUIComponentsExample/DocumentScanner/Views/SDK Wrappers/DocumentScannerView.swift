//
//  DocumentScannerView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerView: UIViewControllerRepresentable {
    
    @ObservedObject var pagesContainer: DocumentPagesContainer
        
    init(pagesContainer: DocumentPagesContainer) {
        self.pagesContainer = pagesContainer
    }
    
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

extension DocumentScannerView {
    final class Coordinator: NSObject, SBSDKDocumentScannerViewControllerDelegate {
        
        private let parent: DocumentScannerView
                        
        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                           didSnapDocumentImage documentImage: UIImage,
                                           on originalImage: UIImage,
                                           with result: SBSDKDocumentDetectorResult?, autoSnapped: Bool) {
            
            let documentPage = SBSDKDocumentPage(image: originalImage, polygon: result?.polygon, filter: .none)
            parent.pagesContainer.add(page: documentPage)
        }
    }
}
