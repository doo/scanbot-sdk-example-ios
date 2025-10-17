//
//  PDFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createPDF(from scannedDocument: SBSDKScannedDocument) {
    
    // Create the PDF attributes.
    let pdfAttributes = SBSDKPDFAttributes(author: "Author",
                                           creator: "Creator",
                                           title: "Title",
                                           subject: "Subject",
                                           keywords: "Keywords")
    
    // Create the PDF configuration object using above created attributes.
    // You can also pass custom pageSize, pageDirection, pageFit, dpi, jpegQuality and resamplingMethod.
    let pdfConfiguration = SBSDKPDFConfiguration(attributes: pdfAttributes)
    // Or you can also use the default configuration object.
    let defaultPDFConfiguration = SBSDKPDFConfiguration()
    
    // Create the PDF generator, do not encrypt the PDF.
    let generator = SBSDKPDFGenerator(configuration: pdfConfiguration, useEncryptionIfAvailable: false)
    
    do {
        // If output URL is `nil` the default PDF location of the scanned document will be used.
        try generator.generate(from: scannedDocument)
    } catch {
        SBSDKLog.logError("Failed to render PDF: \(error.localizedDescription)")
    }
}

func createPDF(from image: UIImage) {
    
    // Specify the file URL where the PDF will be saved to.
    guard let outputPDFURL = URL(string: "outputPDF") else { return }
    
    // Create an image storage to save the captured or imported document image to.
    let imagesURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images")
    let imagesLocation = SBSDKStorageLocation.init(baseURL: imagesURL)
    guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: imagesLocation) else { return }
    
    // Create an image ref from UIImage.
    let imageRef = SBSDKImageRef.fromUIImage(image: image)
    
    // Add the image to the image storage.
    imageStorage.add(imageRef)
    
    // Create the PDF attributes.
    let pdfAttributes = SBSDKPDFAttributes(author: "Author",
                                           creator: "Creator",
                                           title: "Title",
                                           subject: "Subject",
                                           keywords: "Keywords")
    
    // Create the PDF configuration object using above created attributes.
    // You can also pass custom pageSize, pageDirection, pageFit, dpi, jpegQuality and resamplingMethod.
    let pdfConfiguration = SBSDKPDFConfiguration(attributes: pdfAttributes, jpegQuality: 100)
    // Or you can also use the default configuration object.
    let defaultPDFConfiguration = SBSDKPDFConfiguration()
    
    // In case you want to encrypt your PDF file, create a crypting provider, using a password and an encryption mode.
    let cryptingProvider = SBSDKCryptingProvider(block: {
        
        // Create and return the AES encrypter with a password and an encryption mode.
        // You can also use other encrypters, like `SBSDKAESGCM`.
        // Make sure, you always create a new instance of the encrypter in this block.
        return SBSDKAESEncrypter(password: "password_example#42", mode: .AES256)
    })
    
    // Set the created crypting provider as the default one for Scanbot SDK.
    // Important: If you set a default crypting provider, all other Scanbot SDK components will also use this encrypter, including all stored images.
    Scanbot.defaultCryptingProvider = cryptingProvider
    
    // Create the PDF generator, enabling encryption.
    let generator = SBSDKPDFGenerator(configuration: pdfConfiguration, useEncryptionIfAvailable: true)
    do {
        // Synchronously generates the PDF from the image storage into a PDF file with the given page size,
        // and saves it to the specified URL.
        try generator.generate(from: imageStorage,
                               output: outputPDFURL)
    } catch {
        SBSDKLog.logError("Failed to generate PDF: \(error.localizedDescription).")
    }
}
