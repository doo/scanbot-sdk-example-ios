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
        let result = analyzer.analyze(on: image)
        
        // Handle the result.
        if let result {
            self.printResult(result)
        }
    }
    
    // Print the result.
    func printResult(_ result: SBSDKDocumentQualityAnalyzerResult) {
        
        print("Document found: \(result.documentFound)")
        print("Cumulative Quality Histogram: \(result.cumulativeQualityHistogram)")
        
        if let orientation = result.orientation {
            print("Orientation of the document: \(orientation)")
        }
        
        if let quality = result.quality {
            switch quality {
            case .veryPoor:
                print("The quality of the document is very poor")
            case .poor:
                print("The quality of the document is quite poor")
            case .reasonable:
                print("The quality of the document is reasonable")
            case .good:
                print("The quality of the document is good")
            case .excellent:
                print("The quality of the document is excellent")
            default: break
            }
        }
    }
}
