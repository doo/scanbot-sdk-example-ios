//
//  ImageProcessingSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

import Foundation
import ScanbotSDK

class ImageProcessingSwiftViewController: UIViewController {
    
    func asyncImageFilter() {
        
        // Create an instance of an input image.
        guard let inputImage = UIImage(named: "documentImage") else { return }
        
        // Create an instance of `SBSDKImageProcessor` passing the input image to the initializer.
        let processor = SBSDKImageProcessor(image: inputImage)
        
        // Perform operations like rotating, resizing and applying filters to the image.
        // Rotate the image.
        processor.rotate(.clockwise90)
        
        // Resize the image.
        processor.resize(size: 700)
        
        // Create the instances of the filters you want to apply.
        let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
        let filter2 = SBSDKBrightnessFilter(brightness: 0.4)
        
        // Apply the filters.
        processor.applyFilters([filter1, filter2])
        
        // Retrieve the processed image.
        let processedImage = processor.processedImage
    }
    
    func detectAndApplyPolygon() {
        
        // Create an instance of an input image.
        guard let inputImage = UIImage(named: "documentImage") else { return }

        // Create a document detector.
        let detector = SBSDKDocumentDetector()

        // Let the document detector run on the input image.
        let result = detector.detectDocumentPolygon(on: inputImage,
                                                    visibleImageRect: .zero,
                                                    smoothingEnabled: false,
                                                    useLiveDetectionParameters: false)

        // Check the result and retrieve the detected polygon.
        if result?.status == .ok, let polygon = result?.polygon {

            // If the result is an acceptable polygon, we warp the image into the polygon.
            let processor = SBSDKImageProcessor(image: inputImage)
            
            // Crop the image using the polygon.
            processor.crop(polygon: polygon)
            
            // Retrieve the processed image.
            let processedImage = processor.processedImage
            
        } else {
            
            // No acceptable polygon found.
        }
    }
}
