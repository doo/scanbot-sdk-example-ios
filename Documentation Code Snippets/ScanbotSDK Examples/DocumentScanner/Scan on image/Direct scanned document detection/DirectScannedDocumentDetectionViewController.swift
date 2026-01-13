//
//  DirectScannedDocumentDetectionViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.25.
//

import Foundation
import ScanbotSDK

class DirectScannedDocumentDetectionViewController {
    
    func detect(on scannedDocument: SBSDKScannedDocument) {
        
        // Iterate over the pages.
        scannedDocument.pages.forEach { page in
            
            do {
                // Create an instance of a document scanner.
                let scanner = try SBSDKDocumentScanner()
                
                // Retrieve scanned document's original image.
                guard let image = page.originalImage else { return }
                
                // Run detection on the image.
                let result = try scanner.run(image: image)
                
                // Check the result and retrieve the detected polygon.
                if result.status == .ok, let polygon = result.polygon {
                    
                    // Apply the polygon on to the page.
                    try page.apply(polygon: polygon)
                    
                } else {
                    
                    // No acceptable polygon found.
                }
            }
            catch {
                print("Error running document scanner: \(error.localizedDescription)")
            }
        }
    }
}
