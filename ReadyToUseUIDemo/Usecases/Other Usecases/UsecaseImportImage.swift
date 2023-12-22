//
//  UsecaseImportImage.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseImportImage: Usecase, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let document: SBSDKDocument
    private var completionHandler: (() -> ())?
    
    init(document: SBSDKDocument, completion: (() -> ())?) {
        self.document = document
        self.completionHandler = completion
        super.init()
    }

    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        presenter.present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        DispatchQueue(label: "OperationQueue").async { [weak self] in
            let detectionResult = SBSDKDocumentDetector().detectDocumentPolygon(on: image,
                                                                       visibleImageRect: .zero,
                                                                       smoothingEnabled: false,
                                                                       useLiveDetectionParameters: false)
            let page = SBSDKDocumentPage(image: image, polygon: detectionResult?.polygon, filter: .none)
            self?.document.add(page)
        }
        DispatchQueue.main.async {
            picker.presentingViewController?.dismiss(animated: true, completion: {
                self.didFinish()
                self.completionHandler?()
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
