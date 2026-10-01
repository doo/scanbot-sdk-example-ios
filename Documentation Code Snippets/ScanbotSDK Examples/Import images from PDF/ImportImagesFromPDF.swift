//
//  ImportImagesFromPDF.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func createScannedDocumentFromPDF(pdfURL: URL) {
    
    // Create an instance of the PDF page extractor.
    let pageExtractor = SBSDKPDFImageExtractor()
    
    do {
        // Synchronously extracts the pages from the PDF and returns them as `SBSDKScannedDocument`.
        // Each page of the PDF will be a separate `SBSDKScannedPage`.
        let scannedDocument = try pageExtractor.scannedDocument(from: pdfURL)
    }
    catch {
        print("Error creating scanned document from PDF: \(error.localizedDescription)")
    }
}

func createImagesFromPDF(pdfURL: URL) {
    
    // Create an instance of the PDF page extractor.
    let pageExtractor = SBSDKPDFImageExtractor()
    pageExtractor.scaleFactor = 2.0 // Optional: Set scaling for the extracted images.
    
    // Extracts the pages from the PDF and returns an array of `SBSDKImageRef`.
    let images = pageExtractor.extract(from: pdfURL)
    
    // The `scaleFactor` set above is applied to the images extracted by `extract(from:)`.
    let scaledImages = pageExtractor.extract(from: pdfURL)
}
