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
            let result = analyzer.analyze(on: unfilteredDocumentImage)
            
            // Handle the result.
            if let result {
                self.printResult(result)
            }
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
