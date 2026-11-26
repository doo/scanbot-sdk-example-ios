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

            // Step 2: run OCR on the page.
            let result = try await runOCR(on: document)

            // Step 3: create the JSON.
            let json = try createJSON(from: result)

            // Pass the JSON to your LLM.
            print(json)

        } catch SBSDKError.operationCanceled {
            // The user canceled the scanner.

        } catch {
            print("Scanning or OCR failed: \(error.localizedDescription)")
        }
    }
    // @EndTag("Scanning a page")

    // @Tag("Running OCR")
    func runOCR(on document: SBSDKScannedDocument) async throws -> SBSDKOCRResult {

        // Run OCR with the default settings.
        let configuration = SBSDKOCREngineConfiguration.scanbotOCR()
        let ocrEngineManager = SBSDKOCREngineManager(configuration: configuration)
        return try await ocrEngineManager.recognize(from: document)
    }
    // @EndTag("Running OCR")

    // @Tag("Creating the JSON")
    struct LineText: Encodable {
        let text: String
        let box: [Int]
    }

    struct PageText: Encodable {
        let lines: [LineText]
    }

    func createJSON(from result: SBSDKOCRResult) throws -> String {

        // Collect the text and the position of every line.
        var pages: [PageText] = []
        for page in result.pages {
            var lines: [LineText] = []
            for block in page.blocks {
                for line in block.lines {
                    lines.append(LineText(text: line.text, box: box(around: line.roi)))
                }
            }
            pages.append(PageText(lines: lines))
        }

        // Create the JSON.
        let data = try JSONEncoder().encode(["pages": pages])
        return String(decoding: data, as: UTF8.self)
    }

    // The box around the polygon of a line: x, y, width, and height in pixels of the page image.
    func box(around roi: [CGPoint]) -> [Int] {
        let xs = roi.map { $0.x }
        let ys = roi.map { $0.y }
        let left = xs.min() ?? 0
        let top = ys.min() ?? 0
        let width = (xs.max() ?? 0) - left
        let height = (ys.max() ?? 0) - top
        return [left, top, width, height].map { Int($0.rounded()) }
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
