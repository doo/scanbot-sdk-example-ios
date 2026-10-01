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
        
        do {
            // Create an instance of a document scanner.
            let detector = try SBSDKDocumentScanner()
            
            // Create an image ref from the picked image.
            let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
            
            // Run detection on the picked image.
            let result = try detector.run(image: imageRef)
            
            // Check the result and retrieve the detected polygon.
            if result.status == .ok, let polygon = result.polygon {
                
                // If the result has an acceptable polygon, we warp the image into the polygon.
                let processor = SBSDKImageProcessor()
                
                // Crop the image to the polygon.
                let processedImageRef = try processor.crop(image: imageRef, polygon: polygon)
                
                // Convert ImageRef to UIImage if needed.
                let processedUIImage = try processedImageRef.toUIImage()
                
            } else {
                
                // No acceptable polygon found.
            }
        }
        catch {
            print("Error detecting document: \(error.localizedDescription)")
        }
    }
}
