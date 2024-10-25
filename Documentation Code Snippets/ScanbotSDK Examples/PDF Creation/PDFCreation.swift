//
//  PDFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createPDF(from scannedDocument: SBSDKScannedDocument) {
    
    // Create pdf attributes.
    let pdfAttributes = SBSDKPDFAttributes(author: "Author",
                                           creator: "Creator",
                                           title: "Title",
                                           subject: "Subject",
                                           keywords: "Keywords")
    
    // Create default PDF configuration object using above created attributes.
    // You can also pass custom pageSize, pageDirection, pageFit, dpi, jpegQuality and resamplingMethod.
    let pdfConfiguration = SBSDKPDFConfiguration(attributes: pdfAttributes)
    
    // Create pdf renderer.
    let renderer = SBSDKPDFRenderer(configuration: pdfConfiguration,
                                    ocrConfiguration: .scanbotOCR(),
                                    encrypter: nil)
    
    do {
        //If output URL is `nil`the default PDF location of the scanned document will be used.
        try renderer.renderScannedDocument(scannedDocument)
    } catch {
        SBSDKLog.logError("Failed to render PDF: \(error.localizedDescription)")
    }
}

func createPDF(from image: UIImage) {
    // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
    guard let outputPDFURL = URL(string: "outputPDF") else { return }
    
    // Create an image storage to save the captured or imported document image to
    let imagesURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images")
    let imagesLocation = SBSDKStorageLocation.init(baseURL: imagesURL)
    guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: imagesLocation) else { return }
    
    // Add the image to the image storage
    imageStorage.add(image)
    
    // In case you want to encrypt your PDF file, create encrypter using a password and an encryption mode.
    let encrypter = SBSDKAESEncrypter(password: "password_example#42", mode: .AES256)
    
    // Create pdf attributes.
    let pdfAttributes = SBSDKPDFAttributes(author: "Author",
                                           creator: "Creator",
                                           title: "Title",
                                           subject: "Subject",
                                           keywords: "Keywords")
    
    // Create default PDF configuration object using above created attributes.
    // You can also pass custom pageSize, pageDirection, pageFit, dpi, jpegQuality and resamplingMethod.
    let pdfConfiguration = SBSDKPDFConfiguration(attributes: pdfAttributes, jpegQuality: 100)
    
    // Create pdf renderer.
    let renderer = SBSDKPDFRenderer(configuration: pdfConfiguration,
                                    ocrConfiguration: .scanbotOCR(),
                                    encrypter: nil)
    do {
        // Synchronously renders the images from the image storage into a PDF file with the given page size, and saves the PDF to the specified URL.
        try renderer.renderImageStorage(imageStorage,
                                        output: outputPDFURL)
    } catch {
        SBSDKLog.logError("Failed to generate PDF: \(error.localizedDescription).")
    }
}
