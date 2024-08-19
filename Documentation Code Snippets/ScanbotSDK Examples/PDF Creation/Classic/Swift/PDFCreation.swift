//
//  PDFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createPDF() {
    // Create an image storage to save the captured document images to
    let imagesURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images")
    let imagesLocation = SBSDKStorageLocation.init(baseURL: imagesURL)
    guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: imagesLocation) else { return }

    // Define the indices of the images in the image storage you want to render into a PDF, e.g. the first 3.
    // To include all images you can simply pass nil for the indexSet. The indexSet is validated internally.
    // You don't need to concern yourself with the validity of all the indices.
    let indexSet = IndexSet(integersIn: 0...2)

    // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
    guard let outputPDFURL = URL(string: "outputPDF") else { return }

    // In case you want to encrypt your PDF file, create encrypter using a password and an encryption mode.
    let encrypter = SBSDKAESEncrypter(password: "password_example#42", mode: .AES256)

    // Create the OCR configuration for a searchable PDF (HOCR).
    let ocrConfiguration = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
    
    // Create the default PDF rendering options.
    let options = SBSDKPDFRendererOptions()
    
    // Set the OCR Configuration.
    options.ocrConfiguration = ocrConfiguration // Comment this line to not generate HOCR
    
    // Create the PDF renderer and pass the PDF options to it.
    let renderer = SBSDKPDFRenderer(options: options)
    
    // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
    let progress = renderer.renderImageStorage(imageStorage, 
                                               indexSet: indexSet, 
                                               encrypter: encrypter, 
                                               output: outputPDFURL) { finished, error in

        if finished && error == nil {
            // Now you can access the pdf file at outputPDFURL.
        }        
    }
}
