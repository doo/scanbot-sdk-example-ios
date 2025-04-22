//
//  ManualDataParser.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.10.24.
//

import UIKit
import ScanbotSDK

func parseDataManually() {
    
    // Some raw barcode string.
    let rawBarcodeString = "(01)02804086001986(3103)000220(15)220724(30)01(3922)00198"
    
    // Instantiate the parser.
    let parser = SBSDKBarcodeDocumentParser(extractedDocumentFormats: [.gs1])
    
    // Run the parser and check the result.
    if let document = parser.parse(from: rawBarcodeString) {
        
        // Parse the resulted document as a GS1 document.
        if let gs1ParsedDocument = SBSDKBarcodeDocumentModelGS1(document: document) {
            
        // Retrieve the elements.
           let elements = gs1ParsedDocument.elements
            
            // Enumerate over the elements.
            for element in elements {
                
                // Do something with the element.
                
                print("\(element.dataTitle?.value?.text) = \(element.rawValue?.value?.text)")
            }
        }
    }
}
