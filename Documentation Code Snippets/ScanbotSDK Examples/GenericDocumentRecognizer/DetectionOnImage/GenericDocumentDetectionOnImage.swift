//
//  GenericDocumentDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

import Foundation
import ScanbotSDK

func detectGenericDocumentOnImage() {
    
    // Image containing generic document.
    guard let image = UIImage(named: "genericDocumentImage") else { return }
    
    // Types of generic documents you want to detect.
    let typesToDetect = SBSDKDocumentsModelRootType.allDocumentTypes
    
    // Create a configuration builder.
    let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
    
    // Pass the above types here as required.
    builder.setAcceptedDocumentTypes(typesToDetect)
    
    // Creates an instance of `SBSDKGenericDocumentRecognizer`.
    let detector = SBSDKGenericDocumentRecognizer(configuration: builder.buildConfiguration())
    
    // Returns the result after running detector on the image.
    let result = detector.recognizeDocument(on: image)
}
