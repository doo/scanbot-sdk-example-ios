//
//  DirectDocumentDetectionViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.08.24.
//

import Foundation
import ScanbotSDK

class DirectDocumentDetectionViewController: UIViewController,
                                             UIImagePickerControllerDelegate,
                                             UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present an image picker.
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) {
            self.detectDocument(on: pickedImage)
        }
    }
    
    func detectDocument(on pickedImage: UIImage) {
        
        // Create an instance of a document scanner.
        let detector = SBSDKDocumentScanner()
        
        // Run detection on the picked image.
        let result = detector.scan(from: pickedImage)
        
        // Check the result and retrieve the detected polygon.
        if result?.status == .ok, let polygon = result?.polygon {

            // If the result has an acceptable polygon, we warp the image into the polygon.
            let processor = SBSDKImageProcessor(uiImage: pickedImage)
            
            // Crop the image to the polygon.
            processor.applyCrop(polygon: polygon)
            
            // Retrieve the processed image.
            let processedImage = processor.processedImage
            
        } else {
            
            // No acceptable polygon found.
        }
    }
}
