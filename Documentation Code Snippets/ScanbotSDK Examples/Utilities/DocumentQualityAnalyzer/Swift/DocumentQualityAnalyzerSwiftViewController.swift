//
//  DocumentQualityAnalyzerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 14.11.23.
//

import UIKit
import ScanbotSDK

class DocumentQualityAnalyzerSwiftViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the analyzer.
        let analyzer = SBSDKDocumentQualityAnalyzer()
        
        // Set the desired image.
        if let image = UIImage(named: "testDocument") {
            
            // Analyze the quality of the image.
            let quality = analyzer.analyze(on: image)
            
            // Handle the result.
            self.printResult(quality: quality)
        }
    }
    
    // Print the result.
    func printResult(quality: SBSDKDocumentQuality) {
        
        switch quality {
        case .noDocument:
            print("No document was found")
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
        @unknown default: break
        }
    }
}
