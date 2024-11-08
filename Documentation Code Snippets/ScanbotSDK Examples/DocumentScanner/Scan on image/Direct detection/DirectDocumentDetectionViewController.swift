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
        
        // Present image picker
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
        
        // Create an instance of a document detector
        let detector = SBSDKDocumentDetector()
        
        // Run detection on the picked image
        let result = detector.detectDocument(on: pickedImage)
        
        // Check the result and retrieve the detected polygon.
        if result?.status == .ok, let polygon = result?.polygon {

            // If the result is an acceptable polygon, we warp the image into the polygon.
            let processor = SBSDKImageProcessor(uiImage: pickedImage)
            
            // You can crop the image using the polygon if you want.
            processor.applyCrop(polygon: polygon)
            
            // Retrieve the processed image.
            let processedImage = processor.processedImage
            
        } else {
            
            // No acceptable polygon found.
        }
    }
}
