//
//  TIFFDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class TIFFDemoViewController: UIViewController {
    @IBOutlet private var imagesCountLabel: UILabel?
    private var images: [SBSDKImageRef] = []
    
    private func showFile(at filePath: String) {
        
    }
    
    @IBAction private func createTIFFDidPress(_ sender: Any) {
        createTIFF(isBinarized: false)
    }
    
    @IBAction private func createBinarizedTIFFDidPress(_ sender: Any) {
        createTIFF(isBinarized: true)
    }
    
    @IBAction private func importImageButtonDidPress(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    private func createTIFF(isBinarized: Bool) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).last?.path else { return }
        let filePath = "\(documentsDirectory)/\(UUID().uuidString.lowercased()).tiff"
        guard let fileURL = URL(string: filePath) else { return }
        let parameters = SBSDKTIFFGeneratorParameters.defaultParameters
        parameters.dpi = 200
        if isBinarized {
            parameters.binarizationFilter = SBSDKCustomBinarizationFilter()            
            parameters.compression = SBSDKCompressionMode.ccittT6
            parameters.userFields = [
                SBSDKUserField(tag: 65000, name: "SomeStringField", value: SBSDKUserFieldStringValue(value: "String value")),
                SBSDKUserField(tag: 65001, name: "SomeIntField", value: SBSDKUserFieldDoubleValue(value: 123.5)),
                SBSDKUserField(tag: 65535, name: "SomeDoubleField", value: SBSDKUserFieldDoubleValue(value: 123.5))
            ]
        } else {
            parameters.compression = SBSDKCompressionMode.lzw
        }
        Task {
            do {
                let generator = try SBSDKTIFFGenerator(parameters: parameters, useEncryptionIfAvailable: false)
                if let result = try await generator.generate(from: images, to: fileURL) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let alert = UIAlertController(title: "File saved",
                                                      message: "At path: \(result.path)",
                                                      preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default,
                                                     handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.handleError(error)
                }
            }
        }
    }
}

extension TIFFDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            images.append(imageRef)
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.imagesCountLabel?.text = "Images added: \(self?.images.count ?? 0)"
        }
    }
}
