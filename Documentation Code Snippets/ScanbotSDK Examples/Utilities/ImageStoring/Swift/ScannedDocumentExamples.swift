//
//  ScannedPageExamples.swift
//  ScanbotSDK Examples
//
//  Created by Daniil Voitenko on 29.08.24.
//

import Foundation
import ScanbotSDK

func createScannedDocument(with images: [UIImage]) {
    
    // Create a new document with the specified maximum image size.
    // Setting the limit to 0, effectively disables the size limit.
    let scannedDocument = SBSDKScannedDocument(documentImageSizeLimit: 0)
    
    // add images to the document.
    images.forEach { scannedDocument.addPage(with: $0) }
}

func createFromDocument(_ document: SBSDKDocument) -> SBSDKScannedDocument? {
    // Create the scanned document using convenience initializer `init?(document:documentImageSizeLimit:)`
    // `SBSDKDocument` doesn't support `documentImageSizeLimit`, but you can add it to unify size of the documents.
    let scannedDocument = SBSDKScannedDocument(document: document, documentImageSizeLimit: 2048)
    
    // Return newly created scanned document
    return scannedDocument
}

func accessImageURLs(of scannedDocument: SBSDKScannedDocument) {
    // get an array of original image URLs from scanned document.
    let originalImageURIs = scannedDocument.pages.compactMap { $0.originalImageURI }
    
    // get an array of document image (processed, rotated, cropped and filtered) URLs from scanned document.
    let documentImageURIs = scannedDocument.pages.compactMap { $0.documentImageURI }
    
    // get an array of screen-sized preview image URLs from scanned document.
    let previewImageURIs = scannedDocument.pages.compactMap { $0.documentImagePreviewURI }
}

func reorderPagesInScannedDocument(_ scannedDocument: SBSDKScannedDocument) {
    // Move last and first images in the scanned document.
    // Create source index.
    let sourceIndex = scannedDocument.pageCount - 1
    
    // create destination index.
    let destinationIndex = 0
    
    // Reorder images in the scanned document.
    scannedDocument.movePage(at: sourceIndex, to: destinationIndex)
}

func removeAllPagesFromScannedDocument(_ scannedDocument: SBSDKScannedDocument) {
    // Call the `removeAllPages(onError:)` to remove all pages from the document, but keep the document itself.
    scannedDocument.removeAllPages { page, error in
        // Handle error.
        SBSDKLog.logError("Failed to remove page \(page) with error: \(error)")
    }
}

func removePDFFromScannedDocument(with scannedDocument: SBSDKScannedDocument) {
    // Create a file manager instance.
    let fileManager = FileManager.default
    do {
        // Try to remove a PDF file at URL provided by `SBSDKScannedDocument`.
        try fileManager.removeItem(at: scannedDocument.pdfURI)
    } catch {
        // Handle error.
        SBSDKLog.logError("Failed to remove a PDF at \(scannedDocument.pdfURI)")
    }
}

func removeTIFFFromScannedDocument(with scannedDocument: SBSDKScannedDocument) {
    // Create a file manager instance.
    let fileManager = FileManager.default
    do {
        // Try to remove a TIFF file at URL provided by `SBSDKScannedDocument`.
        try fileManager.removeItem(at: scannedDocument.tiffURI)
    } catch {
        // Handle error.
        SBSDKLog.logError("Failed to remove a PDF at \(scannedDocument.tiffURI)")
    }
}

func deleteScannedDocument(with scannedDocument: SBSDKScannedDocument) {
    do {
        // Try to delete scanned document completely, including all images and generated files from disk.
        try scannedDocument.delete()
    } catch {
        // Handle error
        SBSDKLog.logError("Failed to delete scanned document: \(error)")
    }
}
