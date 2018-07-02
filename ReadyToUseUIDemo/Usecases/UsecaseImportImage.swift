//
//  UsecaseImportImage.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

class UsecaseImportImage: Usecase, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.presentingViewController?.dismiss(animated: true, completion: {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            guard let uuid = SBSDKUIPageFileStorage.default().add(image.sbsdk_imageWithFixedOrientation()!) else {
                return
            }
            let page = SBSDKUIPage(pageFileID: uuid, polygon: nil)
            page.detectDocument(true)
            self.document.add(page)
            
            if let presenter = self.presenter {
                UsecaseBrowseDocumentPages(document: self.document).start(presenter: presenter)
            }

            self.didFinish()
        })
    }
}
