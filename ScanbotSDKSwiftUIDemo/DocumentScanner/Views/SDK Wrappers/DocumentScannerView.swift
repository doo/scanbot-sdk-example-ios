//
//  DocumentScannerView.swift
//  DocumentScannerSwiftUIDemo (iOS)
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

final class DocumentScannerView: UIViewControllerRepresentable {
    
    @ObservedObject var pagesContainer: DocumentPagesContainer
        
    private let parentController: UIViewController
    private let scannerViewController: SBSDKDocumentScannerViewController
    
    init(pagesContainer: DocumentPagesContainer) {
        self.pagesContainer = pagesContainer
        self.parentController = UIViewController()
        self.scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self.parentController,
                                                                        parentView: self.parentController.view,
                                                                        delegate: nil)!
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, scannerViewController: scannerViewController)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        scannerViewController.delegate = context.coordinator
        return parentController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension DocumentScannerView {
    final class Coordinator: NSObject, SBSDKDocumentScannerViewControllerDelegate {
        
        private let parent: DocumentScannerView
        private let scanner: SBSDKDocumentScannerViewController
                
        init(_ parent: DocumentScannerView, scannerViewController: SBSDKDocumentScannerViewController) {
            self.parent = parent
            self.scanner = scannerViewController
        }
        
        func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                           didSnapDocumentImage documentImage: UIImage,
                                           on originalImage: UIImage,
                                           with result: SBSDKDocumentDetectorResult, autoSnapped: Bool) {
            let documentPage = SBSDKUIPage(image: documentImage,
                                           polygon: result.polygon,
                                           filter: SBSDKImageFilterTypeNone)
            parent.pagesContainer.add(page: documentPage)
        }
    }
}
