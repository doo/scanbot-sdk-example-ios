//
//  GenericDocumentViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class GenericDocumentViewController: UIViewController {
    var scannerViewController: SBSDKGenericDocumentRecognizerViewController?
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
        
        builder.setAcceptedDocumentTypes(documentTypes())
        
        scannerViewController = SBSDKGenericDocumentRecognizerViewController(parentViewController: self,
                                                                             parentView: view, 
                                                                             configuration: builder.buildConfiguration(),
                                                                             delegate: self)
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.hidesWhenStopped = true
        view.addSubview(indicator!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        indicator?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    private func documentTypes() -> [SBSDKDocumentsModelRootType] {
        return SBSDKDocumentsModelRootType.allDocumentTypes
    }
    
    private func display(document: SBSDKGenericDocument, with sourceImage: UIImage) {
        if navigationController?.topViewController == self {
            let resultsVC = GenericDocumentResultViewController.make(with: document, sourceImage: sourceImage)
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
    
    @IBAction private func selectImageButtonDidPress(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension GenericDocumentViewController: SBSDKGenericDocumentRecognizerViewControllerDelegate {
    func documentRecognizerViewController(_ controller: SBSDKGenericDocumentRecognizerViewController,
                                          didRecognize result: SBSDKGenericDocumentRecognitionResult,
                                          on image: UIImage) {
        if result.status == .success {
            indicator?.stopAnimating()
        }
        if let document = result.document, let sourceImage = document.crop?.toUIImage() {
            controller.resetDocumentAccumulation()
            display(document: document, with: sourceImage)
        }
    }
}

extension GenericDocumentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
            
            builder.setAcceptedDocumentTypes(self.documentTypes())
            
            let recognizer = SBSDKGenericDocumentRecognizer(configuration: builder.buildConfiguration())
                        
            if let image = image, let document = recognizer.recognizeDocument(on: image)?.document {
                self.display(document: document, with: image)
            }
        }
    }
}
