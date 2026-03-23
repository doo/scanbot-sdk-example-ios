//
//  ImageEnhancerFromImageViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 18.03.26.
//

import UIKit
import ScanbotSDK

class ImageEnhancerFromScannedPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For instance, a perspective correction of images in scanned pages.
        enhanceFromScannedPage()
    }
    
    func enhanceFromScannedPage() {
        
        // Create the parameters.
        let parameters = SBSDKDocumentStraighteningParameters()
        
        
        // Configure the properties.
        // e.g
        parameters.straighteningMode = .straighten
        parameters.aspectRatios = [SBSDKAspectRatio(width: 1, height: 1),
                                   SBSDKAspectRatio(width: 16, height: 9),
                                   SBSDKAspectRatio(width: 3, height: 4)]
        let corners: [CGPoint] = [
            CGPoint(x: 0.05, y: 0.05),
            CGPoint(x: 0.95, y: 0.05),
            CGPoint(x: 0.95, y: 0.95),
            CGPoint(x: 0.05, y: 0.95)
        ]
        
        do {
            
            // Retrieve the scanned document.
            let document = try SBSDKScannedDocument.loadDocument(documentUuid: "SOME_SAVED_UUID")
            
            // Retrieve the selected document page.
            let page = try document.page(at: 0)
            
            // Apply the straightening parameters.
            try page.apply(straighteningParameters: parameters)
            
            // All the following resulting images have been straightened.
            let unfilteredStraightenedImage = page.unfilteredDocumentImage
            
            let documentStraightenedImage = page.documentImage
            
            let documentPreviewStraightenedImage = page.documentImagePreview
        }
        catch {
            print("Error straightening the document page: \(error.localizedDescription)")
        }
    }
}
