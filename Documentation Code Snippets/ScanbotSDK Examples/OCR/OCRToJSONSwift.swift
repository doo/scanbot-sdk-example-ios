//
//  OCRToJSONSwift.swift
//  ScanbotSDK Examples
//
//  Created by Adam Kvítek on 25.11.26.
//

import Foundation
import ScanbotSDK

class OCRToJSONSwiftViewController: UIViewController {

    // @Tag("Scanning a page")
    // Add the following to your view controller:
    func scanPage() async {

        // Step 1: scan one page.
        let configuration = SBSDKUI2DocumentScanningFlow()
        configuration.outputSettings.pagesScanLimit = 1

        do {
            let document = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)

            // Steps 2 and 3: run OCR on the page and create the JSON.
            let json = try await createJSON(from: document)

            // Pass the JSON to your LLM.
            print(json)

        } catch SBSDKError.operationCanceled {
            // The user canceled the scanner.

        } catch {
            print("Scanning or OCR failed: \(error.localizedDescription)")
        }
    }
    // @EndTag("Scanning a page")

    // @Tag("Creating the JSON")
    struct PageText: Encodable {
        let lines: [String]
    }

    func createJSON(from document: SBSDKScannedDocument) async throws -> String {

        // Step 2: run OCR on the scanned page.
        let configuration = SBSDKOCREngineConfiguration.scanbotOCR()
        let ocrEngineManager = SBSDKOCREngineManager(configuration: configuration)
        let result = try await ocrEngineManager.recognize(from: document)

        // Step 3: collect the text of every line.
        var pages: [PageText] = []
        for page in result.pages {
            var lines: [String] = []
            for block in page.blocks {
                for line in block.lines {
                    lines.append(line.text)
                }
            }
            pages.append(PageText(lines: lines))
        }

        // Create the JSON.
        let data = try JSONEncoder().encode(["pages": pages])
        return String(decoding: data, as: UTF8.self)
    }
    // @EndTag("Creating the JSON")

    // @Tag("Converting the OCR result to JSON")
    func convertToJSON(result: SBSDKOCRResult) -> String {

        // Each page returns its blocks, lines, words, and glyphs as JSON with `toJson()`.
        // `SBSDKOCRResult` doesn't provide `toJson()`, so wrap the pages in one JSON object.
        let pagesJSON = result.pages.map { $0.toJson() }.joined(separator: ",")
        return "{\"pages\":[\(pagesJSON)]}"
    }
    // @EndTag("Converting the OCR result to JSON")
}
