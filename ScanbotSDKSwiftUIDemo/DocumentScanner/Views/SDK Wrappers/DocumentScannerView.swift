//
//  DocumentScannerView.swift
//  DocumentScannerSwiftUIDemo (iOS)
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
        let parentViewController = UIViewController()
        let scannerViewController = SBSDKDocumentScannerViewController(parentViewController: parentViewController,
                                                                        parentView: parentViewController.view,
                                                                        delegate: nil)!
        scannerViewController.delegate = context.coordinator
        return parentViewController
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
                                           with result: SBSDKDocumentDetectorResult, autoSnapped: Bool) {
            let documentPage = SBSDKUIPage(image: originalImage,
                                           polygon: result.polygon,
                                           filter: SBSDKImageFilterTypeNone)
            parent.pagesContainer.add(page: documentPage)
        }
    }
}
