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
    
    do {
        
        // Instantiate the parser.
        let parser = try SBSDKBarcodeDocumentParser(acceptedFormats: [.gs1])
        
        // Run the parser and check the result.
        let document = try parser.parse(rawString: rawBarcodeString)
            
        // Get the parsed document.
        guard let parsedDocument = document.parsedDocument else { return }
        
        // Parse the resulted document as a GS1 document.
        if let gs1ParsedDocument = SBSDKBarcodeDocumentModelGS1(document: parsedDocument) {
            
            // Retrieve the elements.
            let elements = gs1ParsedDocument.elements
            
            // Enumerate over the elements.
            for element in elements {
                    
                // Do something with the element.
                if let key = element.dataTitle?.value?.text, let value = element.rawValue?.value?.text {
                    print("\(key) = \(value)")
                }
            }
        }
    }
    catch {
        print("Error parsing document: \(error.localizedDescription)")
    }
}
