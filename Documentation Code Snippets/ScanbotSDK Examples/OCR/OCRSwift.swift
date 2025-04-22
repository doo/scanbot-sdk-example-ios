//
//  OCRSwift.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

import Foundation
import ScanbotSDK

class OCRSwiftViewController {
    
    func performTextRecognition() {
        
        // The file URL of the image to be analyzed.
        guard let imageURL = URL(string: "...") else { return }
        
        // Create the OCR configuration object, either with the new ML engine...
        let configuration_ML = SBSDKOCREngineConfiguration.scanbotOCR()
        
        // ...or with the legacy engine
        let configuration_Legacy 
        = SBSDKOCREngineConfiguration.tesseract(withLanguageString: "de+en")
        
        // Pass the configuration object to the initializer of the optical character recognizer engine.
        let recognizer = SBSDKOCREngine(configuration: configuration_ML /* or configuration_Legacy */)
        
        // Run the recognizeOn... method of the recognizer.
        recognizer.recognize(from: imageURL) { result, error in
            
            // In the completion handler check for the error and result.
            if let result = result, error == nil {
                
                // At the end enumerate all words and log them to the console together with their confidence values and bounding boxes.
                for page in result.pages {
                    for word in page.words {
                        print("Word: \(word.text), Confidence: \(word.confidenceValue), Polygon: \(word.polygon.description)")
                    }
                }
            }
        }
    }
}

