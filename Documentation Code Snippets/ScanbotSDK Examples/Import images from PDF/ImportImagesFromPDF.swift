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
    let pageExtractor = SBSDKPDFPagesExtractor()
    
    // Synchronously extract the pages from PDF and returns them as `SBSDKScannedDocument`.
    // Each page of the PDF will be a separate `SBSDKScannedPage`.
    let scannedDocument = pageExtractor.scannedDocument(from: pdfURL)
}

func createImagesFromPDF(pdfURL: URL) {
    
    // Create an instance of the PDF page extractor.
    let pageExtractor = SBSDKPDFPagesExtractor()
    
    // Extract the pages from the pdf and returns an array of UIImage
    let images = pageExtractor.images(from: pdfURL)
    
    // You can also use `images(fromPDF:scaling)` method to extract images with a scaling applied.
    let scaledImages = pageExtractor.images(from: pdfURL, scaling: 2.0)
}
