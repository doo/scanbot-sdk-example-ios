//
//  TIFFDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class TIFFDemoViewController: UIViewController {
    @IBOutlet private var imagesCountLabel: UILabel?
    private var images: [UIImage] = []
    
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
        let parameters = SBSDKTIFFImageWriterParameters.default()
        parameters.dpi = 200
        if isBinarized {
            parameters.binarize = true
            parameters.compression = SBSDKTIFFImageWriterCompressionOptions.COMPRESSION_CCITT_T6
            parameters.userDefinedFields = [SBSDKTIFFImageWriterUserDefinedField(stringValue: "String value",
                                                                                 fieldName: "SomeStringField",
                                                                                 fieldTag: 65000),
                                            SBSDKTIFFImageWriterUserDefinedField(numericValue: NSNumber(value: 123),
                                                                                 fieldName: "SomeIntField",
                                                                                 fieldTag: 65001),
                                            SBSDKTIFFImageWriterUserDefinedField(numericValue: NSNumber(value: 123.5),
                                                                                 fieldName: "SomeDoubleField",
                                                                                 fieldTag: 65535)]
        } else {
            parameters.compression = SBSDKTIFFImageWriterCompressionOptions.COMPRESSION_LZW
        }
        if SBSDKTIFFImageWriter.writeTIFF(images, fileURL: fileURL, parameters: parameters) {
            let alert = UIAlertController(title: "File saved",
                                          message: "At path: \(fileURL.path)",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension TIFFDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(image)
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.imagesCountLabel?.text = "Images added: \(self?.images.count ?? 0)"
        }
    }
}
