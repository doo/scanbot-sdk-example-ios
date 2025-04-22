//
//  DetectorsManager.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 24.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

protocol DetectorsManagerDelegate: AnyObject {
    func scanner(_ scanner: SBSDKBarcodeScanner,
                 didFindBarcodes result: SBSDKBarcodeScannerResult?)
    
    func recognizer(_ recognizer: SBSDKHealthInsuranceCardRecognizer,
                    didFindEHIC result: SBSDKEuropeanHealthInsuranceCardRecognitionResult?)
    
    func extractor(_ extractor: SBSDKDocumentDataExtractor,
                   didExtractDocument result: SBSDKDocumentDataExtractionResult?)
    
    func scanner(_ scanner: SBSDKMedicalCertificateScanner,
                 didScanMedicalCertificate result: SBSDKMedicalCertificateScanningResult?)
    
    func scanner(_ scanner: SBSDKCheckScanner,
                 didScanCheck result: SBSDKCheckScanningResult?)
    
    func scanner(_ scanner: SBSDKCreditCardScanner, 
                 didScanCreditCard result: SBSDKCreditCardScanningResult?)
    
    func scanner(_ scanner: SBSDKMRZScanner,
                 didScanMRZ result: SBSDKMRZScannerResult?)
    
    func scanner(_ scanner: SBSDKDocumentScanner, didFindPolygon result : SBSDKDocumentDetectionResult?)
    
}

final class DetectorsManager {
    enum Detector: CaseIterable {
        case barcode, ehic, genericDocument, mrz, medicalCertificate, documentScanner, check, creditCard
        
        var detectorName: String {
            switch self {
            case .barcode:
                return "Barcode"
            case .ehic:
                return "EU Health Card (EHIC)"
            case .genericDocument:
                return "ID Card, Passport, Drivers License"
            case .mrz:
                return "Machine Readable Zone"
            case .medicalCertificate:
                return "Medical Certificate"
            case .documentScanner:
                return "Document Scanner"
            case .check:
                return "Check Scanner"
            case.creditCard:
                return "Credit Card Scanner"
            }
        }
    }
    
    let allDetectors = Detector.allCases
    weak var delegate: DetectorsManagerDelegate?
    
    init(delegate: DetectorsManagerDelegate?) {
        self.delegate = delegate
    }
    
    func detectInfo(on image: UIImage, using detector: Detector) {
        switch detector {
        case .barcode:
            let scanner = SBSDKBarcodeScanner()
            let result = scanner.scan(from: image)
            delegate?.scanner(scanner, didFindBarcodes: result)
        case .ehic:
            let recognizer = SBSDKHealthInsuranceCardRecognizer()
            let result = recognizer.recognize(from: image)
            delegate?.recognizer(recognizer, didFindEHIC: result)
        case .genericDocument:
            let builder = SBSDKDocumentDataExtractorConfigurationBuilder()
            
            let extractor = SBSDKDocumentDataExtractor(configuration: builder.buildConfiguration())
            let result = extractor.extract(from: image)
            delegate?.extractor(extractor, didExtractDocument: result)
        case .mrz:
            let scanner = SBSDKMRZScanner()
            let result = scanner.scan(from: image)
            delegate?.scanner(scanner, didScanMRZ: result)
        case .medicalCertificate:
            let scanner = SBSDKMedicalCertificateScanner()
            let result = scanner.scan(from: image, parameters: SBSDKMedicalCertificateScanningParameters())
            delegate?.scanner(scanner, didScanMedicalCertificate: result)
        case .documentScanner:
            let configuration = SBSDKDocumentScannerConfiguration()
            let scanner = SBSDKDocumentScanner(configuration: configuration)
            let result = scanner.scan(from: image)
            delegate?.scanner(scanner, didFindPolygon: result)
        case .check:
            let scanner = SBSDKCheckScanner()
            let result = scanner.scan(from: image)
            delegate?.scanner(scanner, didScanCheck: result)
        case .creditCard:
            let configuration = SBSDKCreditCardScannerConfiguration()
            configuration.scanningMode = .singleShot
            let scanner = SBSDKCreditCardScanner(configuration: configuration)
            let result = scanner.scan(from: image)
            delegate?.scanner(scanner, didScanCreditCard: result)
        }
    }
    
    private func makeFinderRect(for image: UIImage) -> CGRect {
        let width = image.size.width
        let height = image.size.height
        let finderHeight = width / 4
        return CGRect(x: 0, y: (height / 2) - (finderHeight / 2), width: width, height: finderHeight)
    }
}

extension SBSDKEuropeanHealthInsuranceCardRecognitionResult {
    var stringRepresentation: String {
        var result: String = ""
        for field in fields {
            result += "\(field.value)\n"
        }
        return result
    }
}

extension SBSDKGenericDocumentField {
    
    var stringRepresentation: String {
        if let value {
            return "\(type.name): \(value.text) \(value.confidence)"
        } else {
            return ""
        }
    }
}
extension SBSDKMRZScannerResult {
    /// Returns a string representation of all fields.
    var stringRepresentation: String {
        var result = ""
        if !rawMRZ.isEmpty {
            result += "Raw string:\n"
            result += rawMRZ + "\n"
        }
        
        guard let document = document else { return result }
        
        result += "\(document.type.name)\n"
        
        guard let fields = document.allFields(includeEmptyFields: false) else { return result }
        
        for field in fields {
            result.append(field.stringRepresentation)
        }
        
        return result
    }
}

extension SBSDKCreditCardScanningResult {
    var stringRepresentation: String {
        let result = [
            "Credit Card status: \(self.scanningStatus.name)",
            self.creditCard?.fields
                .compactMap { "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }
                .joined(separator: "\n") ?? ""
        ].joined(separator: "\n")
        return result
    }
}

extension SBSDKCreditCardScanningStatus {
    var name: String {
        switch self {
        case .errorNothingFound: return "NOTHING_FOUND"
        case .success: return "SUCCESS"
        case .incomplete: return "INCOMPLETE"
        @unknown default: return "Unknown credit card scanning status"
        }
    }
}
