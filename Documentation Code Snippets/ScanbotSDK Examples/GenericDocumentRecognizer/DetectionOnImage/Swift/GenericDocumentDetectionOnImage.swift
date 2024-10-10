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
    let typesToDetect = SBSDKGenericDocumentRootType.allDocumentTypes
    
    // Creates an instance of `SBSDKGenericDocumentRecognizer`.
    let detector = SBSDKGenericDocumentRecognizer(acceptedDocumentTypes: typesToDetect)
    
    // Returns the result after running detector on the image.
    let result = detector.recognize(on: image)
}
