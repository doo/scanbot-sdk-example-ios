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
    
    // Add images to the document.
    images.forEach { scannedDocument.addPage(with: $0) }
}

func createFromDocument(_ document: SBSDKDocument) -> SBSDKScannedDocument? {
    // Create the scanned document using convenience initializer `init?(document:documentImageSizeLimit:)`.
    let scannedDocument = SBSDKScannedDocument(document: document, documentImageSizeLimit: 2048)
    
    // Return the newly created scanned document.
    return scannedDocument
}

func accessImageURLs(of scannedDocument: SBSDKScannedDocument) {
    // Get an array of URLs to each page's original image.
    let originalImageURIs = scannedDocument.pages.compactMap { $0.originalImageURI }
    
    // Get an array of URLs to each page's document image (processed, rotated, cropped and filtered).
    let documentImageURIs = scannedDocument.pages.compactMap { $0.documentImageURI }
    
    // Get an array of URLs to the each page's screen-sized document preview image.
    let previewImageURIs = scannedDocument.pages.compactMap { $0.documentImagePreviewURI }
}

func reorderPagesInScannedDocument(_ scannedDocument: SBSDKScannedDocument) {
    // Move the last page of the scanned document to the first place.
    // Create source index of the last page.
    let sourceIndex = scannedDocument.pageCount - 1
    
    // Create destination index at position 0.
    let destinationIndex = 0
    
    // Execute the move operation on the scanned document.
    scannedDocument.movePage(at: sourceIndex, to: destinationIndex)
}

func removeAllPagesFromScannedDocument(_ scannedDocument: SBSDKScannedDocument) {
    // Call the `removeAllPages(onError:)` to remove all pages from the document, but keep the document itself.
    scannedDocument.removeAllPages { page, error in
        // Eventually handle the error.
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
        // Eventually handle the error.
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
        // Eventually handle the error.
        SBSDKLog.logError("Failed to remove a PDF at \(scannedDocument.tiffURI)")
    }
}

func deleteScannedDocument(with scannedDocument: SBSDKScannedDocument) {
    do {
        // Try to delete scanned document completely, including all images and generated files from disk.
        try scannedDocument.delete()
    } catch {
        // Eventually handle the error.
        SBSDKLog.logError("Failed to delete scanned document: \(error)")
    }
}
