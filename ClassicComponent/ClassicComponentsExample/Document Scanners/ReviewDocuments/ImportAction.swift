//
//  ImportAction.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 21.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit

final class ImportAction: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var completionHandler: (UIImage?, URL?)->()
    
    init(completionHandler: @escaping (UIImage?, URL?)->()) {
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
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let path = info[UIImagePickerController.InfoKey.imageURL] as? URL // UIImagePickerControllerImageURL
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        
        completionHandler(image, path)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionHandler(nil, nil)
    }
}
