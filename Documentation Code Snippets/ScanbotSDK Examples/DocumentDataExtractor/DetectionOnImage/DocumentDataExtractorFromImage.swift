//
//  GenericDocumentDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func extractDocumentDataFromImage() {
    
    // The image containing the document.
    guard let image = UIImage(named: "genericDocumentImage") else { return }
    
    // Create configuration for the extractor.
    let configuration = SBSDKDocumentDataExtractorConfiguration(
        configurations: [SBSDKDocumentDataExtractorCommonConfiguration(
            acceptedDocumentTypes: [SBSDKDocumentsModelConstants.europeanDriverLicenseFrontDocumentType,
                                    SBSDKDocumentsModelConstants.europeanDriverLicenseBackDocumentType]
        )]
    )
    
    // Enable the crops image extraction.
    configuration.returnCrops = true
    
    do {
        
        // Create an instance of extractor.
        let extractor = try SBSDKDocumentDataExtractor(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run the extractor on the image.
        let result = try extractor.run(image: imageRef)
        
        // Get the cropped image.
        let croppedImage = try result.croppedImage?.toUIImage()
    }
    catch {
        print("Error extracting document data: \(error.localizedDescription)")
    }
}
