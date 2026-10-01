//
//  ImageEnhancerFromScannedPageSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ImageEnhancerFromScannedPageSwiftUIView: View {
    
    var body: some View {
        Text("Image Enhancer")
            .task {
                // For instance, a perspective correction of images in scanned pages.
                enhanceFromScannedPage()
            }
    }
    
    func enhanceFromScannedPage() {
        
        // Create the parameters.
        let parameters = SBSDKDocumentStraighteningParameters()
        
        
        // Configure the properties.
        // e.g
        parameters.straighteningMode = .straighten
        
        // By default, aspect ratio of the straightened document is automatically determined based on the detected document corners.
        // If the document is significantly deformed, the estimated aspect ratio may be inaccurate.
        // In such cases, providing a list of expected aspect ratios may help improve the accuracy of the straightening.
        parameters.aspectRatios = [SBSDKAspectRatio(width: 1, height: 1),
                                   SBSDKAspectRatio(width: 16, height: 9),
                                   SBSDKAspectRatio(width: 3, height: 4)]
        
        // Clockwise coordinates of the document in the image.
        let corners: [CGPoint] = [
            CGPoint(x: 0.05, y: 0.05), // top-left corner
            CGPoint(x: 0.95, y: 0.05), // top-right corner
            CGPoint(x: 0.95, y: 0.95), // bottom-right corner
            CGPoint(x: 0.05, y: 0.95)  // bottom-left corner
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

#Preview {
    ImageEnhancerFromScannedPageSwiftUIView()
}
