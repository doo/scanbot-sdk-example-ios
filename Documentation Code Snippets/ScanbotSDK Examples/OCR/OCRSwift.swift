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
        
        // Pass the configuration object to the initializer of the optical character recognizer engine manager.
        let ocrEngineManager = try SBSDKOCREngineManager(configuration: configuration_ML /* or configuration_Legacy */)
        
        // Run the recognizer.
        // The OCR engine manager has different methods that enable support of running recognizer on various data types.
        // e.g SBSDKImageRef, Image's URL, SBSDKImageStorage, SBSDKDocument or SBSDKScannedDocument.
        // And also supports there corresponding asynchronous methods.
        ocrEngineManager.recognize(from: imageURL) { result, error in
            
            // In the completion handler, check for the error and result.
            if let result = result, error == nil {
                
                // At the end enumerate all pages and their corresponding blocks and lines.
                for page in result.pages {
                    
                }
            }
        }
    }
}

