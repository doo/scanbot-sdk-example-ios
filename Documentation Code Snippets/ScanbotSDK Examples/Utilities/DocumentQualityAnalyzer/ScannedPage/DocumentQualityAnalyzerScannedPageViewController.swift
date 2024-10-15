//
//  DocumentQualityAnalyzerScannedPageViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 14.11.23.
//

import UIKit
import ScanbotSDK

class DocumentQualityAnalyzerScannedPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        analyzeScannedPageQuality()
    }
    
    func analyzeScannedPageQuality() {
        
        // Retrieve the scanned document
        guard let document = SBSDKScannedDocument(documentUuid: "SOME_SAVED_UUID") else { return }
        
        // Retrieve the selected document page.
        guard let page = document.page(at: 0) else { return }
        
        // Initialize the analyzer.
        let analyzer = SBSDKDocumentQualityAnalyzer()
        
        // Run the analyzer on the document image
        // If you have a filtered applied and you wish to run the analyzer on the unfiltered image
        if let unfilteredDocumentImage = page.unfilteredDocumentImage {
            // otherwise you can just simply use the `page.documentImage`
            
            // Run the quality analyzer on the image.
            let quality = analyzer.analyze(on: unfilteredDocumentImage)
            
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
