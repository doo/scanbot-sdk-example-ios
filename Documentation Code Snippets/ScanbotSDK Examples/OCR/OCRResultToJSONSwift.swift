//
//  OCRResultToJSONSwift.swift
//  ScanbotSDK Examples
//
//  Created by Adam Kvítek on 23.11.26.
//

import Foundation
import ScanbotSDK

class OCRResultToJSONSwift {
    
    // Runs OCR on a scanned document and returns the complete result as JSON.
    // @Tag("Converting the OCR result to JSON")
    func convertToJSON(document: SBSDKScannedDocument) async throws -> String {
        
        // Run OCR with the ML engine on all pages of the scanned document.
        let ocrEngineManager = SBSDKOCREngineManager(configuration: SBSDKOCREngineConfiguration.scanbotOCR())
        let result = try await ocrEngineManager.recognize(from: document)
        
        // Each page returns its blocks, lines, words, and glyphs as JSON with `toJson()`.
        // `SBSDKOCRResult` doesn't provide `toJson()`, so wrap the pages in one JSON object.
        let pagesJSON = result.pages.map { $0.toJson() }.joined(separator: ",")
        return "{\"pages\":[\(pagesJSON)]}"
    }
    // @EndTag("Converting the OCR result to JSON")
    
    // Returns only the text of the lines, for example to pass the text to a language model.
    // @Tag("Creating a compact JSON from the OCR result")
    func convertToCompactJSON(result: SBSDKOCRResult) throws -> String {
        
        struct CompactPage: Encodable {
            let page: Int
            let lines: [String]
        }
        
        // Words with a low confidence are often icons, logos, or QR codes read as characters.
        let minimumWordConfidence = 0.5
        
        let pages = result.pages.enumerated().map { index, page in
            let lines = page.blocks.flatMap { $0.lines }.compactMap { line -> String? in
                let words = line.words.filter { $0.confidence >= minimumWordConfidence }.map { $0.text }
                return words.isEmpty ? nil : words.joined(separator: " ")
            }
            return CompactPage(page: index + 1, lines: lines)
        }
        let data = try JSONEncoder().encode(pages)
        return String(decoding: data, as: UTF8.self)
    }
    // @EndTag("Creating a compact JSON from the OCR result")
}
