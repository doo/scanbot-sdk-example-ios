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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var page: SBSDKUIPage?
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            if let uuid = SBSDKUIPageFileStorage.default().add(image.sbsdk_imageWithNormalizedOrientation()!) {
                page = SBSDKUIPage(pageFileID: uuid, polygon: nil)
            }
        }
        if let page = page {
            page.detectDocument(true)
            self.document.add(page)
        }
        picker.presentingViewController?.dismiss(animated: true, completion: {
            self.didFinish()
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
