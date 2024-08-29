//
//  ImportImagesFromPDF.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func createDocumentsFromPDF(pdfURL: URL) {
    
    // Creates an instance of `SBSDKPDFPagesExtractor`
    let pageExtractor = SBSDKPDFPagesExtractor()
    
    // Extracts pages from the pdf and returns an array of UIImage
    let images = pageExtractor.images(from: pdfURL)
    
    // You can also use `images(fromPDF:scaling)` method to extract images with a scaling applied
    let scaledImages = pageExtractor.images(from: pdfURL, scaling: 2.0)
}

func createImagesFromPDF(pdfURL: URL) {
    
    // Creates an instance of `SBSDKPDFPagesExtractor`
    let pageExtractor = SBSDKPDFPagesExtractor()
    
    // Synchronously Extracts pages from PDF and returns them as `SBSDKScannedDocument`. Each page of the PDF will be a separate `SBSDKScannedPage`.
    let scannedDocument = pageExtractor.scannedDocument(from: pdfURL)
}
