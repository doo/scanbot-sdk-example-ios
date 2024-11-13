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
        
        // Create an instance of `SBSDKImageProcessor` passing the input image to the initializer.
        let processor = SBSDKImageProcessor(uiImage: image)
        
        // Perform operations like rotating, resizing and applying filters to the image.
        // Rotate the image.
        processor.applyRotation(.clockwise90)
        
        // Resize the image.
        processor.applyResize(700)
        
        // Create the instances of the filters to be applied.
        let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
        let filter2 = SBSDKBrightnessFilter(brightness: 0.4)
        
        // Apply the filters.
        processor.applyFilters([filter1, filter2])
        
        // Retrieve the processed image.
        let processedImage = processor.processedImage
    }
}
