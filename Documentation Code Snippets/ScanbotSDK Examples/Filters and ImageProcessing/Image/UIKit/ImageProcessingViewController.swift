//
//  ImageProcessingViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

import Foundation
import ScanbotSDK

class ImageProcessingViewController: UIViewController,
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
            self.applyFiltersAndRotate(image: pickedImage)
        }
    }
    
    func applyFiltersAndRotate(image: UIImage) {
        
        // Create an instance of Image Processor.
        let processor = SBSDKImageProcessor()
        
        // Create an image ref from UIImage.
        var imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Perform operations like rotating, resizing and applying filters to the image.
        do {
            // Rotate the image.
            imageRef = try processor.rotate(image: imageRef, rotation: .clockwise90)
            
            // Resize the image.
            imageRef = try processor.resize(image: imageRef, size: 700)
            
            // Create the instances of the filters to be applied.
            let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
            let filter2 = SBSDKBrightnessFilter(brightness: 0.4)
            
            // Apply the filters.
            imageRef = try processor.applyFilters(image: imageRef, filters: [filter1, filter2])
            
            // Convert ImageRef to UIImage if needed.
            let processedUIImage = try? imageRef.toUIImage()
        }
        catch {
            print("Error processing image: \(error.localizedDescription)")
        }
    }
}
