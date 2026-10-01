//
//  DirectDocumentDetectionSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DirectDocumentDetectionSwiftUIView: View {
    
    @State private var processedUIImage: UIImage?
    @State private var errorMessage: String?
    
    var body: some View {
        
        VStack {
            // Present an image picker.
            ExampleImagePicker { pickedImage in
                detectDocument(on: pickedImage)
            }
            
            if let processedUIImage {
                Image(uiImage: processedUIImage)
                    .resizable()
                    .scaledToFit()
            }
            
            if let errorMessage {
                Text("Error detecting document: \(errorMessage)")
            }
        }
    }
    
    func detectDocument(on pickedImage: UIImage) {
        
        do {
            // Create an instance of a document scanner.
            let detector = try SBSDKDocumentScanner()
            
            // Create an image ref from the picked image.
            let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
            
            // Run detection on the picked image.
            let result = try detector.run(image: imageRef)
            
            // Check the result and retrieve the detected polygon.
            if result.status == .ok, let polygon = result.polygon {
                
                // If the result has an acceptable polygon, we warp the image into the polygon.
                let processor = SBSDKImageProcessor()
                
                // Crop the image to the polygon.
                let processedImageRef = try processor.crop(image: imageRef, polygon: polygon)
                
                // Convert ImageRef to UIImage if needed.
                let processedUIImage = try processedImageRef.toUIImage()
                self.processedUIImage = processedUIImage
                
            } else {
                
                // No acceptable polygon found.
            }
        }
        catch {
            print("Error detecting document: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    DirectDocumentDetectionSwiftUIView()
}
