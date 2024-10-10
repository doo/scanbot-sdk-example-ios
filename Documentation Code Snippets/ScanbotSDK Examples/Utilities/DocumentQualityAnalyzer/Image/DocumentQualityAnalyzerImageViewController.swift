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
        
        // Present image picker
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) {
            self.analyzeQuality(on: pickedImage)
        }
    }
    
    func analyzeQuality(on image: UIImage) {
        
        // Initialize the analyzer.
        let analyzer = SBSDKDocumentQualityAnalyzer()
        
        // Analyze the quality of the image.
        let quality = analyzer.analyze(on: image)
        
        // Handle the result.
        self.printResult(quality: quality)
    }
    
    // Print the result.
    func printResult(quality: SBSDKDocumentQuality) {
        
        switch quality {
        case .noDocument:
            print("No document was found")
        case .veryPoor:
            print("The quality of the document is very poor")
        case .poor:
            print("The quality of the document is poor")
        case .reasonable:
            print("The quality of the document is reasonable")
        case .good:
            print("The quality of the document is good")
        case .excellent:
            print("The quality of the document is excellent")
        @unknown default: break
        }
    }
}
