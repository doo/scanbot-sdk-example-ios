//
//  ImportImagesFromPDF.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

import Foundation
import ScanbotSDK

func createImagesFromPDF() {
    
    // The path where the pdf is stored.
    guard let pdfURL = URL(string: "<path_to_pdf>") else { return }
    
    // Creates an instance of `SBSDKPDFPagesExtractor`
    let pageExtractor = SBSDKPDFPagesExtractor()
    
    // Extracts pages from the pdf and returns an array of UIImage
    let images = pageExtractor.images(from: pdfURL)
    
    // You can also use `images(fromPDF:scaling)` method to extract images with a scaling applied
    let scaledImages = pageExtractor.images(from: pdfURL, scaling: 2.0)
}
