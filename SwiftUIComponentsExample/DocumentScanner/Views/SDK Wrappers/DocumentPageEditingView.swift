//
//  DocumentPageEditingView.swift
//  DocumentScannerSwiftUIDemo (iOS)
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentPageEditingView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var editingPage: SBSDKDocumentPage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard let editingPage = editingPage else { fatalError("There must be the page to edit") }

        let configuration = SBSDKUICroppingScreenConfiguration.defaultConfiguration
        let viewController = SBSDKUICroppingViewController.create(page: editingPage,
                                                                  configuration: configuration,
                                                                  delegate: context.coordinator)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension DocumentPageEditingView {
    final class Coordinator: NSObject, SBSDKUICroppingViewControllerDelegate {
        
        private let parent: DocumentPageEditingView
        
        init(_ parent: DocumentPageEditingView) {
            self.parent = parent
        }
        
        func croppingViewController(_ viewController: SBSDKUICroppingViewController,
                                    didFinish changedPage: SBSDKDocumentPage) {
            parent.editingPage = changedPage
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func croppingViewControllerDidCancel(_ viewController: SBSDKUICroppingViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
