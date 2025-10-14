//
//  ImportAction.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 21.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class ImportAction: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var completionHandler: (SBSDKImageRef?)->()
    
    init(completionHandler: @escaping (SBSDKImageRef?)->()) {
        self.completionHandler = completionHandler
    }
    
    func showImagePicker(on presenter: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        presenter.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            completionHandler(imageRef)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionHandler(nil)
    }
}
