//
//  GenericDocumentDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func recognizeGenericDocumentOnImage() {
    
    // The image containing the generic document.
    // Note: The image's rotation property, as specified in its metadata, is respected and not ignored.
    guard let image = UIImage(named: "genericDocumentImage") else { return }
    
    // The types of generic documents to be recognized.
    let typesToDetect = SBSDKDocumentsModelRootType.allDocumentTypes
    
    // Create a configuration builder.
    let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
    
    // Pass the above types here as required.
    builder.setAcceptedDocumentTypes(typesToDetect)
    
    // Create an instance of `SBSDKGenericDocumentRecognizer`.
    let recognizer = SBSDKGenericDocumentRecognizer(configuration: builder.buildConfiguration())
    
    // Run the recognizer on the image.
    let result = recognizer.recognizeDocument(on: image)
}
