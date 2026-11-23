//
//  LanguageModelTextSwift.swift
//  ScanbotSDK Examples
//
//  Created by Adam Kvítek on 23.11.26.
//

import Foundation
import ScanbotSDK

class LanguageModelTextSwift {

    // @Tag("Scanning the pages")
    @MainActor
    func startScanning(presenter: UIViewController) {

        // Scan as many pages as the user wants.
        let configuration = SBSDKUI2DocumentScanningFlow()
        configuration.outputSettings.pagesScanLimit = 0

        do {
            try SBSDKUI2DocumentScannerController.present(on: presenter,
                                                          configuration: configuration) { _, document, error in
                if let document {
                    Task {
                        do {
                            // Turn the scanned pages into a compact JSON.
                            let json = try await self.makeJSON(from: document)

                            // Pass the JSON to your language model.
                            print(json)
                        } catch {
                            presenter.sbsdk_showError(error)
                        }
                    }
                } else if let error, (error as? SBSDKError)?.isCanceled != true {
                    presenter.sbsdk_showError(error)
                }
            }
        } catch {
            presenter.sbsdk_showError(error)
        }
    }
    // @EndTag("Scanning the pages")

    // @Tag("Preparing a page for OCR")
    func prepareForOCR(_ image: SBSDKImageRef) throws -> (upright: SBSDKImageRef, forOCR: SBSDKImageRef) {

        // Detect the text orientation. The input scales let the analyzer find large text too.
        // Input scales other than [1.0] require `maxImageSize` 0.
        let configuration = SBSDKDocumentQualityAnalyzerConfiguration()
        configuration.inputScales = [1.0, 0.5, 0.25, 0.125]
        configuration.maxImageSize = 0
        // Keep the default `minRequiredOrientationConfidence` of 0.9.
        // A lower threshold lets the analyzer turn pages it's unsure about, for example photo posters with little text.
        let analysis = try SBSDKDocumentQualityAnalyzer(configuration: configuration).run(image: image)

        // The orientation is in degrees counterclockwise. Rotating the image clockwise by the same angle makes it upright.
        let rotation: SBSDKImageRotation
        switch Int((analysis.orientation / 90).rounded()) {
        case 1:
            rotation = .clockwise90
        case -1:
            rotation = .counterclockwise90
        case 2, -2:
            rotation = .clockwise180
        default:
            rotation = .none
        }
        let imageProcessor = SBSDKImageProcessor()
        let uprightImage = try imageProcessor.rotate(image: image, rotation: rotation)

        // Limit the longest edge for OCR. At full camera resolution, the engine misses large text.
        return (uprightImage, try imageProcessor.limitSize(uprightImage, sizeLimit: 1400))
    }
    // @EndTag("Preparing a page for OCR")

    // @Tag("Putting the lines in reading order")
    // Text to place among the lines, for example the content of a QR code, with its position in the OCR image.
    struct PlacedText {
        let text: String
        let roi: [CGPoint]
    }

    func readingOrder(of page: SBSDKPage, placedTexts: [PlacedText]) -> [String] {

        struct PlacedLine {
            let text: String
            let top: CGFloat
            let bottom: CGFloat
            let left: CGFloat
        }

        // Leave out words with a low confidence, and lines without a letter or digit.
        // They're often icons, logos, or QR codes read as characters.
        var lines: [PlacedLine] = page.blocks.flatMap { $0.lines }.compactMap { line in
            let text = line.words.filter { $0.confidence >= 0.5 }.map { $0.text }.joined(separator: " ")
            guard text.rangeOfCharacter(from: .alphanumerics) != nil else { return nil }
            let ys = line.roi.map { $0.y }
            let xs = line.roi.map { $0.x }
            return PlacedLine(text: text, top: ys.min() ?? 0, bottom: ys.max() ?? 0, left: xs.min() ?? 0)
        }

        // Sort the placed texts in like lines, so each one ends up next to its label on the page.
        lines += placedTexts.map { placedText in
            let ys = placedText.roi.map { $0.y }
            let xs = placedText.roi.map { $0.x }
            return PlacedLine(text: placedText.text, top: ys.min() ?? 0, bottom: ys.max() ?? 0, left: xs.min() ?? 0)
        }

        // Sort the lines from top to bottom.
        // Lines whose vertical centers are close share a row, from left to right.
        var rows: [[PlacedLine]] = []
        for line in lines.sorted(by: { $0.top < $1.top }) {
            let isInLastRow = rows.last?.contains { other in
                let centerDistance = abs((other.top + other.bottom) / 2 - (line.top + line.bottom) / 2)
                return centerDistance < 0.5 * min(line.bottom - line.top, other.bottom - other.top)
            } ?? false
            if isInLastRow {
                rows[rows.count - 1].append(line)
            } else {
                rows.append([line])
            }
        }
        return rows.map { row in row.sorted { $0.left < $1.left }.map { $0.text }.joined(separator: " | ") }
    }
    // @EndTag("Putting the lines in reading order")

    // @Tag("Creating the JSON")
    struct PageText: Encodable {
        let page: Int
        let lines: [String]
        let barcodes: [Barcode]
    }

    struct Barcode: Encodable {
        let format: String
        let text: String
    }

    func makeJSON(from document: SBSDKScannedDocument) async throws -> String {
        let ocrEngineManager = SBSDKOCREngineManager(configuration: SBSDKOCREngineConfiguration.scanbotOCR())
        let barcodeScanner = try SBSDKBarcodeScanner()
        var pages: [PageText] = []

        for (index, page) in document.pages.enumerated() {
            guard let image = page.documentImage else { continue }
            let prepared = try prepareForOCR(image)

            // OCR doesn't read the content of QR codes. The Barcode Scanner does, for example a link.
            let barcodeItems = try barcodeScanner.run(image: prepared.upright).barcodes

            // Place the content of each barcode where the barcode is on the page.
            // The normalized quad is relative to the upright image, so scale it to the OCR image.
            let ocrImageInfo = try prepared.forOCR.info()
            let placedTexts = barcodeItems.map { item in
                PlacedText(text: "[\(item.format.name): \(item.text)]",
                           roi: item.quadNormalized.map {
                               CGPoint(x: $0.x * CGFloat(ocrImageInfo.width), y: $0.y * CGFloat(ocrImageInfo.height))
                           })
            }

            // Run OCR on the prepared image, then put the lines and the barcodes in reading order.
            let result = try await ocrEngineManager.recognize(from: prepared.forOCR)
            let lines = result.pages.flatMap { readingOrder(of: $0, placedTexts: placedTexts) }
            let barcodes = barcodeItems.map { Barcode(format: $0.format.name, text: $0.text) }

            pages.append(PageText(page: index + 1, lines: lines, barcodes: barcodes))
        }
        let data = try JSONEncoder().encode(["pages": pages])
        return String(decoding: data, as: UTF8.self)
    }
    // @EndTag("Creating the JSON")
}
