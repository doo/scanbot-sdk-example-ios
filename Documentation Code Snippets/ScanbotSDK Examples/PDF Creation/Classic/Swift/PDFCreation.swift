//
//  PDFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createPDF(from scannedDocument: SBSDKScannedDocument) {
    
    // Create the OCR configuration for a searchable PDF (HOCR).
    let ocrConfiguration = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
    
    // Create the default PDF rendering options.
    let options = SBSDKPDFRendererOptions()
    
    // Set the OCR Configuration.
    options.ocrConfiguration = ocrConfiguration // Comment this line to not generate HOCR
    
    // Create the PDF renderer and pass the PDF options to it.
    let renderer = SBSDKPDFRenderer(options: options)
    do {
        try renderer.renderScannedDocument(scannedDocument)
    } catch {
        SBSDKLog.logError("Failed to render PDF: \(error.localizedDescription)")
    }
}

func createPDF(from image: UIImage) {
    // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
    guard let outputPDFURL = URL(string: "outputPDF") else { return }
    
    // Create an image storage to save the captured document images to
    let imagesURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images")
    let imagesLocation = SBSDKStorageLocation.init(baseURL: imagesURL)
    guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: imagesLocation) else { return }
    imageStorage.add(image)
    
    let renderer = SBSDKPDFRenderer(options: .init())
    do {
        try renderer.renderImageStorage(imageStorage, output: outputPDFURL)
    } catch {
        SBSDKLog.logError("Faile to generate PDF: \(error.localizedDescription).")
    }
}
