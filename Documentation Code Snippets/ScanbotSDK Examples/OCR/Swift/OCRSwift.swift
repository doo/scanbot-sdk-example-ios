//
//  OCRSwift.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

import Foundation
import ScanbotSDK

class OCRSwiftViewController {
    
    func textLayoutRecognition() {
        // The file URL of the image we want to analyze.
        guard let imageURL = URL(string: "...") else { return }
        
        // Start the text layout recognition by creating an instance of the recognizer and calling 
        // the recognizeLayout... function on it.
        let recognizer = SBSDKTextLayoutRecognizer()
        recognizer.recognizeLayout(on: imageURL) { result, error in
            
            // In the completion handler check for the error and the result.
            if let result = result, error == nil {
                
                // Now we can work with the result.
                if result.orientation == .up && result.writingDirection == .leftToRight {
                    
                }
            } 
        }
        
        // Or if you need the text orientation only...
        let orientation = recognizer.recognizeTextOrientation(on: imageURL)
        // Now we can work with the result.
        if orientation == .up {
            // Now we can work with the result.
        }
    }
    
    func performTextRecognition() {
        // The file URL of the image we want to analyze.
        guard let imageURL = URL(string: "...") else { return }
        
        // Create the OCR configuration object, either with the new ML engine...
        let configuration_ML = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
        
        // ...or with the legacy engine
        let configuration_Legacy 
        = SBSDKOpticalCharacterRecognizerConfiguration.tesseract(withLanguageString: "de+en")
        
        // Pass the configuration object to the initializer of the optical character recognizer.
        let recognizer = SBSDKOpticalCharacterRecognizer(configuration: configuration_ML /* or configuration_Legacy */)
        
        // Run the recognizeOn... method of the recognizer.
        recognizer.recognize(on: imageURL) { result, error in
            
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

    func createPDF() {
        // Create an image storage to save the captured document images to
        let imagesURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images")
        let imagesLocation = SBSDKStorageLocation.init(baseURL: imagesURL)
        guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: imagesLocation) else { return }

        // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
        guard let outputPDFURL = URL(string: "outputPDF") else { return }


        // Create the OCR configuration for a searchable PDF (HOCR).
        let ocrConfiguration = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
        
        // Create the default PDF rendering options.
        let options = SBSDKPDFRendererOptions()
        
        // Set the OCR Configuration.
        options.ocrConfiguration = ocrConfiguration
        
        // Create the PDF renderer and pass the PDF options to it.
        let renderer = SBSDKPDFRenderer(options: options)
        
        // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
        let progress = renderer.renderImageStorage(imageStorage, 
                                                   indexSet: nil, 
                                                   output: outputPDFURL) { finished, error in

            if finished && error == nil {
                // Now you can access the pdf file at outputPDFURL.
            }        
        }
    }
}

