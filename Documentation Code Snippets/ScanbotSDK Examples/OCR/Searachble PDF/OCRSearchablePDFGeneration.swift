//
//  OCRSearchablePDFGeneration.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.25.
//

import Foundation
import ScanbotSDK


class OCRSearchablePDFGeneration {
    
    func createSearchablePDF(from document: SBSDKScannedDocument) {
        
        // Create a PDF configuration object.
        let pdfConfiguration = SBSDKPDFConfiguration(
            attributes: SBSDKPDFAttributes(author: "",
                                           creator: "",
                                           title: "",
                                           subject: "",
                                           keywords: ""),
            pageSize: .a4,
            pageDirection: .auto,
            pageFit: .none,
            dpi: 200,
            jpegQuality: 100,
            resamplingMethod: .none
        )
        
        // Create an OCR Engine configuration object.
        let ocrConfiguration = SBSDKOCREngineConfiguration.scanbotOCR()
       
        // Create the PDF generator.
        let pdfGenerator = SBSDKPDFGenerator(configuration: pdfConfiguration,
                                             ocrConfiguration: ocrConfiguration,
                                             useEncryptionIfAvailable: false)

        
        // Generate the pdf.
        // You can also pass a custom output URI as a parameter, otherwise the default PDF location of the document `document.pdfURI` is used.
        // The pdf generator also provides an asynchronous `async throws` method to generate pdf out of a document.
        // For the sake of this example, the method with a completion handler, is used.
        pdfGenerator.generate(from: document) { success, error in
            
            if success {
                let pdfUri = document.pdfURI
                
            } else if let error {
                print("Failed to create the pdf. Error: \(error.localizedDescription)")
            }
        }
    }
    
    func createSearchablePDF(from images: [UIImage]) {
        
        // Create a PDF configuration object.
        let pdfConfiguration = SBSDKPDFConfiguration(
            attributes: SBSDKPDFAttributes(author: "",
                                           creator: "",
                                           title: "",
                                           subject: "",
                                           keywords: ""),
            pageSize: .a4,
            pageDirection: .auto,
            pageFit: .none,
            dpi: 200,
            jpegQuality: 100,
            resamplingMethod: .none
        )
        
        // Create an OCR Engine configuration object.
        let ocrConfiguration = SBSDKOCREngineConfiguration.scanbotOCR()
       
        // Create the PDF generator.
        let pdfGenerator = SBSDKPDFGenerator(configuration: pdfConfiguration,
                                             ocrConfiguration: ocrConfiguration,
                                             useEncryptionIfAvailable: false)

        // Create a storage that conforms to `SBSDKImageStoring`. The sdk provides a built-in storage class `SBSDKIndexedImageStorage`.
        // You can also pass your own custom storage class that conforms to `SBSDKImageStoring`.
        
        // You can also specify custom `storageLocation`, a different `fileFormat` of type `SBSDKImageFileFormat` and an
        // encrptor as a parameter. If not, the default location of `SBSDKStorageLocation` and a default
        // file format of type `SBSDKImageFileFormat.JPEG` is used without an encrypter.
        guard let imageStorage = SBSDKIndexedImageStorage() else { return }
        
        // Add your images in the storage.
        images.forEach { image in
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Add image to the storage.
            imageStorage.add(imageRef)
        }
        
        // Create an output URL.
        guard let outputUrl = URL(string: "<output_url") else { return }
        
        // Generate the pdf.
        // The pdf generator also provides an asynchronous `async throws` method.
        // For the sake of this example, the method with a completion handler, is used.
        pdfGenerator.generate(from: imageStorage, output: outputUrl) { success, error in
            
            if success {
                
                // PDF is successfully generated
                
            } else if let error {
                print("Failed to create the pdf. Error: \(error.localizedDescription)")
            }
        }
    }
}
