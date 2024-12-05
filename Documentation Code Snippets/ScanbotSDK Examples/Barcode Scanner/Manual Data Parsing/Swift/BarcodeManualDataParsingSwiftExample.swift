//
//  BarcodeManualDataParsingSwiftExample.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.12.24.
//

import ScanbotSDK

func parseDataManually() {
    
    // Some raw barcode string.
    let rawBarcodeString = "(01)02804086001986(3103)000220(15)220724(30)01(3922)00198"

    // Instantiate the parser.
    let parser = SBSDKBarcodeDocumentParser()

    // Run the parser and check the result.
    if let document = parser.parseDocument(inputString: rawBarcodeString) {
        
        // Parse the resulted document as a GS1 document and retrieve it's elements.
        if let gs1ParsedDocument = SBSDKBarcodeDocumentGS1(document: document),
           let elements = gs1ParsedDocument.elements {
            
            // Enumerate over the elements.
            for element in elements {
                
                // Do something with the element.
                
                print("\(element.dataTitle?.value?.text) = \(element.rawValue?.value?.text)")
            }
        }
    }
}
