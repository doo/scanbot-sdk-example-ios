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
    
    // Synchronously extract the pages from PDF and returns them as `SBSDKScannedDocument`.
    // Each page of the PDF will be a separate `SBSDKScannedPage`.
    let scannedDocument = pageExtractor.scannedDocument(from: pdfURL)
}

func createImagesFromPDF(pdfURL: URL) {
    
    // Create an instance of the PDF page extractor.
    let pageExtractor = SBSDKPDFImageExtractor()
    pageExtractor.scaleFactor = 2.0 // Optional: Set scaling for the extracted images.
    
    // Extract the pages from the PDF and returns an array of UIImage
    let images = pageExtractor.extract(from: pdfURL)
    
    // You can also use `extract(from:scaling:)` method to extract images with a scaling applied.
    let scaledImages = pageExtractor.extract(from: pdfURL)
}
