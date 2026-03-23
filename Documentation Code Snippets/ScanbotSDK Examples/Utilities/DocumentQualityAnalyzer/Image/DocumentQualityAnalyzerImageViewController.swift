//
//  DocumentQualityAnalyzerImageViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 29.08.24.
//

import UIKit
import ScanbotSDK

class DocumentQualityAnalyzerImageViewController: UIViewController,
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
        
        // Retrieve the picked image and analyze its quality.
        picker.dismiss(animated: true) {
            self.analyzeQuality(on: pickedImage)
        }
    }
    
    func analyzeQuality(on image: UIImage) {
        
        // Create the configuration.
        let configuration = SBSDKDocumentQualityAnalyzerConfiguration()
        
        // Configure the properties.
        // e.g
        configuration.maxImageSize = 2000
        configuration.returnQualityHeatmap = false
        
        do {
            
            // Initialize the analyzer.
            let analyzer = try SBSDKDocumentQualityAnalyzer(configuration: configuration)
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Run the quality analyzer on the image.
            let result = try analyzer.run(image: imageRef)
            
            // Handle the result.
            self.printResult(result)
        }
        catch {
            print("Error analyzing the document quality: \(error.localizedDescription)")
        }
    }
    
    // Print the result.
    func printResult(_ result: SBSDKDocumentQualityAnalyzerResult) {
        
        print("Document found: \(result.documentFound)")
        print("Cumulative Quality Histogram: \(result.cumulativeQualityHistogram)")
        print("Orientation of the document: \(result.orientation)")
        
        let quality = result.quality
        switch quality {
        case .uncertain:
            print("The quality of the document is uncertain")
        case .unacceptable:
            print("The quality of the document is unacceptable")
        case .acceptable:
            print("The quality of the document is acceptable")
        default: break
        }
    }
}
