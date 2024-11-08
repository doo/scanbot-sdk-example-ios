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
    
    func recognizer(_ recognizer: SBSDKGenericDocumentRecognizer,
                    didFindDocument result: SBSDKGenericDocumentRecognitionResult?)
    
    func recognizer(_ recognizer: SBSDKMedicalCertificateRecognizer,
                    didFindMedicalCertificate result: SBSDKMedicalCertificateRecognitionResult?)
    
    func recognizer(_ recognizer: SBSDKCheckRecognizer,
                    didFindCheck result: SBSDKCheckRecognitionResult?)
    
    func recognizer(_ recognizer: SBSDKCreditCardRecognizer, 
                    didFindCreditCard result: SBSDKCreditCardRecognitionResult?)
    
    func scanner(_ scanner: SBSDKMRZScanner,
                 didFindMRZ result: SBSDKMRZScannerResult?)
    
    func detector(_ detector: SBSDKDocumentDetector, didFindPolygon result : SBSDKDocumentDetectionResult?)
    
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
                return "Credit Card Recognizer"
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
            let result = scanner.detectBarcodes(on: image)
            delegate?.scanner(scanner, didFindBarcodes: result)
        case .ehic:
            let recognizer = SBSDKHealthInsuranceCardRecognizer()
            let result = recognizer.recognizeEHIC(on: image)
            delegate?.recognizer(recognizer, didFindEHIC: result)
        case .genericDocument:
            let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
            
            let recognizer = SBSDKGenericDocumentRecognizer(configuration: builder.buildConfiguration())
            let result = recognizer.recognizeDocument(on: image)
            delegate?.recognizer(recognizer, didFindDocument: result)
        case .mrz:
            let scanner = SBSDKMRZScanner()
            let result = scanner.scanMRZ(on: image)
            delegate?.scanner(scanner, didFindMRZ: result)
        case .medicalCertificate:
            let recognizer = SBSDKMedicalCertificateRecognizer()
            let result = recognizer.recognizeMedicalCertificate(on: image,
                                                                parameters: SBSDKMedicalCertificateRecognitionParameters())
            delegate?.recognizer(recognizer, didFindMedicalCertificate: result)
        case .documentScanner:
            let configuration = SBSDKDocumentDetectorConfiguration()
            let scanner = SBSDKDocumentDetector(configuration: configuration)
            let result = scanner.detectDocument(on: image)
            delegate?.detector(scanner, didFindPolygon: result)
        case .check:
            let recognizer = SBSDKCheckRecognizer()
            let result = recognizer.recognizeCheck(on: image)
            delegate?.recognizer(recognizer, didFindCheck: result)
        case .creditCard:
            let configuration = SBSDKCreditCardRecognizerConfiguration()
            configuration.recognitionMode = .singleShot
            let recognizer = SBSDKCreditCardRecognizer(configuration: configuration)
            let result = recognizer.recognizeCreditCard(on: image)
            delegate?.recognizer(recognizer, didFindCreditCard: result)
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

extension SBSDKCreditCardRecognitionResult {
    var stringRepresentation: String {
        let result = [
            "Credit Card status: \(self.recognitionStatus.name)",
            self.creditCard?.fields
                .compactMap { "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }
                .joined(separator: "\n") ?? ""
        ].joined(separator: "\n")
        return result
    }
}

extension SBSDKCreditCardRecognitionStatus {
    var name: String {
        switch self {
        case .errorNothingFound: return "NOTHING_FOUND"
        case .success: return "SUCCESS"
        case .incomplete: return "INCOMPLETE"
        @unknown default: return "Unknown credit card recognition status"
        }
    }
}
