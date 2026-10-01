//
//  ImageEnhancerFromImageViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 18.03.26.
//

import UIKit
import ScanbotSDK

class ImageEnhancerFromImageViewController: UIViewController,
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
        
        // Retrieve the picked image and enhance its quality.
        picker.dismiss(animated: true) {
            self.enhance(on: pickedImage)
        }
    }
    
    func enhance(on image: UIImage) {
        
        // Create the parameters.
        let parameters = SBSDKDocumentStraighteningParameters()
        
        // Configure the properties.
        // e.g
        parameters.straighteningMode = .straighten
        
        // By default, aspect ratio of the straightened document is automatically determined based on the detected document corners.
        // If the document is significantly deformed, the estimated aspect ratio may be inaccurate.
        // In such cases, providing a list of expected aspect ratios may help improve the accuracy of the straightening.
        parameters.aspectRatios = [SBSDKAspectRatio(width: 1, height: 1),
                                   SBSDKAspectRatio(width: 16, height: 9),
                                   SBSDKAspectRatio(width: 3, height: 4)]
        
        // Clockwise coordinates of the document in the image.
        let corners: [CGPoint] = [
            CGPoint(x: 0.05, y: 0.05), // top-left corner
            CGPoint(x: 0.95, y: 0.05), // top-right corner
            CGPoint(x: 0.95, y: 0.95), // bottom-right corner
            CGPoint(x: 0.05, y: 0.95)  // bottom-left corner
        ]
        
        do {
            // Initialize the document straightener.
            let straightener = try SBSDKDocumentStraightener.create()
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Straighten the image using the document straightener.
            let straightendedImageRef = try straightener.run(image: imageRef,
                                                             parameters: parameters,
                                                             priorCornersNormalized: corners)
        }
        catch {
            print("Failed to straighten image: \(error.localizedDescription)")
        }
    }
}
