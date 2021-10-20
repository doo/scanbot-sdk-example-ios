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
        
    private let scannerViewController = SBSDKScannerViewController(parentViewController: UIViewController(),
                                                                   imageStorage: nil)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, scannerViewController: scannerViewController)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard let parent = scannerViewController.parent else {
            fatalError("Scanner View Controller must have parent view controller")
        }
        scannerViewController.delegate = context.coordinator
        
        return parent
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension DocumentScannerView {
    final class Coordinator: NSObject, SBSDKScannerViewControllerDelegate {
                
        private let parent: DocumentScannerView
        private let scanner: SBSDKScannerViewController
                
        init(_ parent: DocumentScannerView, scannerViewController: SBSDKScannerViewController) {
            self.parent = parent
            self.scanner = scannerViewController
        }
        
        // MARK: SBSDKScannerViewControllerDelegate
        func scannerControllerWillCaptureStillImage(_ controller: SBSDKScannerViewController) {
            scanner.detectionStatusHidden = true
        }
        
        func scannerController(_ controller: SBSDKScannerViewController,
                               didCapture image: UIImage,
                               with info: SBSDKCaptureInfo) {
            scanner.detectionStatusHidden = false
            let documentPage = SBSDKUIPage(image: image,
                                           polygon: info.detectionResult?.polygon,
                                           filter: SBSDKImageFilterTypeNone)
            parent.pagesContainer.add(page: documentPage)
        }
    }
}
