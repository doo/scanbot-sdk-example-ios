//
//  DocumentDataExtractorViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class DocumentDataExtractorViewController: UIViewController {
    var extractorViewController:  SBSDKDocumentDataExtractorViewController?
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = SBSDKDocumentDataExtractorConfiguration(
            configurations: [SBSDKDocumentDataExtractorCommonConfiguration()]
        )
        config.returnCrops = true
        
        extractorViewController = SBSDKDocumentDataExtractorViewController(parentViewController: self,
                                                                           parentView: view,
                                                                           configuration: config,
                                                                           delegate: self)
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.hidesWhenStopped = true
        view.addSubview(indicator!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        indicator?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    private func display(document: SBSDKGenericDocument, with sourceImage: SBSDKImageRef) {
        if navigationController?.topViewController == self {
            let resultsVC = DocumentDataExtractorResultViewController.make(with: document, sourceImage: sourceImage)
            navigationController?.pushViewController(resultsVC, animated: true)
        }
    }
    
    @IBAction private func selectImageButtonDidPress(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension DocumentDataExtractorViewController: SBSDKDocumentDataExtractorViewControllerDelegate {

    func documentDataExtractorViewController(_ viewController: SBSDKDocumentDataExtractorViewController,
                                             didExtract result: SBSDKDocumentDataExtractionResult,
                                          on image: UIImage) {
        if result.status == .ok || result.status == .okButInvalidDocument || result.status == .okButNotConfirmed {
            indicator?.stopAnimating()
        }
        if let document = result.document, let sourceImage = document.crop {
            viewController.resetDocumentAccumulation()
            display(document: document, with: sourceImage)
        }
    }
}

extension DocumentDataExtractorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let image {
                let config = SBSDKDocumentDataExtractorConfiguration(
                    configurations: [SBSDKDocumentDataExtractorCommonConfiguration()]
                )
                config.returnCrops = true
                
                let recognizer = try? SBSDKDocumentDataExtractor(configuration: config)
                let imageRef = SBSDKImageRef.fromUIImage(image: image)
                
                if let document = try? recognizer?.run(image: imageRef).document {
                    self.display(document: document, with: imageRef)
                }
            }
        }
    }
}
