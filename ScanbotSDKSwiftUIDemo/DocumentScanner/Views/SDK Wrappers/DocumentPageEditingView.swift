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
    @Binding var editingPage: SBSDKUIPage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard let editingPage = editingPage else { fatalError("There must be the page to edit") }

        let configuration = SBSDKUICroppingScreenConfiguration.default()
        let viewController = SBSDKUICroppingViewController.createNew(with: editingPage,
                                                                     with: configuration,
                                                                     andDelegate: context.coordinator)
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
                                    didFinish changedPage: SBSDKUIPage) {
            parent.editingPage = changedPage
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func croppingViewControllerDidCancel(_ viewController: SBSDKUICroppingViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
