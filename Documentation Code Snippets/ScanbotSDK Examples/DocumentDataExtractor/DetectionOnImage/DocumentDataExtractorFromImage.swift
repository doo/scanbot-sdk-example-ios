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
    // Note: The image's rotation property, as specified in its metadata, is respected and not ignored.
    guard let image = UIImage(named: "genericDocumentImage") else { return }
    
    // The types of generic documents to be extracted.
    let typesToDetect = SBSDKDocumentsModelRootType.allDocumentTypes
    
    // Create a configuration builder.
    let builder = SBSDKDocumentDataExtractorConfigurationBuilder()
    
    // Pass the above types here as required.
    builder.setAcceptedDocumentTypes(typesToDetect)
    
    // Create an instance of `SBSDKDocumentDataExtractor`.
    let extractor = SBSDKDocumentDataExtractor(configuration: builder.buildConfiguration())
    
    // Run the extractor on the image.
    let result = extractor.extract(from: image)
}
