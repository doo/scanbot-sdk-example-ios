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
        
        do {
            try analyzeScannedPageQuality()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func analyzeScannedPageQuality() throws {
        
        // Retrieve the scanned document.
        let document = try SBSDKScannedDocument.loadDocument(documentUuid: "SOME_SAVED_UUID")
        
        // Retrieve the selected document page.
        guard let page = document.page(at: 0) else { return }
        
        // Create the configuration.
        let configuration = SBSDKDocumentQualityAnalyzerConfiguration()
        
        // Configure the properties.
        // e.g
        configuration.detectOrientation = true
        configuration.maxImageSize = 2000
        configuration.returnQualityHeatmap = false
        
        do {
            
            // Initialize the analyzer.
            let analyzer = try SBSDKDocumentQualityAnalyzer(configuration: configuration)
            
            // Run the analyzer on the document image.
            // If you have a filter applied and you wish to run the analyzer on the unfiltered image.
            // Otherwise you can just simply use the `page.documentImage`.
            if let unfilteredDocumentImage = page.unfilteredDocumentImage {
                
                // Run the quality analyzer on the image.
                let result = try analyzer.run(image: unfilteredDocumentImage)
                
                // Handle the analyzer result.
                self.printResult(result)
            }
        }
        catch {
            print("Error analyzing the document quality: \(error.localizedDescription)")
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
