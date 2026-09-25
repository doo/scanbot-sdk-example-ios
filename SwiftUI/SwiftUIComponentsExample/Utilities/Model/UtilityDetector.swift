//
//  UtilityDetector.swift
//  SwiftUIComponentsExample
//
//  Detectors and analyzers that run on a still image instead of a live camera stream.
//

import ScanbotSDK

enum UtilityDetector: String, Identifiable, CaseIterable {
    
    case barcode
    case documentDetection
    case mrz
    case check
    case creditCard
    case documentData
    case medicalCertificate
    case documentQuality
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .barcode: return "Barcode Detection"
        case .documentDetection: return "Document Detection"
        case .mrz: return "MRZ Detection"
        case .check: return "Check Detection"
        case .creditCard: return "Credit Card Detection"
        case .documentData: return "Document Data Extraction"
        case .medicalCertificate: return "Medical Certificate Detection"
        case .documentQuality: return "Document Quality Analysis"
        }
    }
    
    /// Runs the detector on the given image and converts its result into a displayable result.
    func run(on image: SBSDKImageRef) throws -> ScanResult {
        switch self {
        case .barcode:
            let result = try SBSDKBarcodeScanner().run(image: image)
            return ScanResult(title: title,
                              fields: result.barcodes.map {
                                  ScanResultField(name: $0.format.name, value: $0.displayText)
                              },
                              rawJSON: result.toJson())
        case .documentDetection:
            let result = try SBSDKDocumentScanner().scan(image: image)
            return ScanResult(title: title,
                              fields: [
                                  ScanResultField(name: "Status", value: "\(result.detectionResult.status)"),
                                  ScanResultField(name: "Aspect ratio",
                                                  value: String(format: "%.2f", result.detectionResult.aspectRatio))
                              ],
                              images: [result.croppedImage?.asUIImage].compactMap { $0 })
        case .mrz:
            let result = try SBSDKMRZScanner().run(image: image)
            return ScanResult(title: title,
                              document: result.document,
                              extraFields: [ScanResultField(name: "Raw MRZ", value: result.rawMRZ)],
                              rawJSON: result.toJson())
        case .check:
            let result = try SBSDKCheckScanner().run(image: image)
            return ScanResult(title: title,
                              document: result.check,
                              images: [result.croppedImage],
                              rawJSON: result.toJson())
        case .creditCard:
            let result = try SBSDKCreditCardScanner().run(image: image)
            return ScanResult(title: title, document: result.creditCard, rawJSON: result.toJson())
        case .documentData:
            let result = try SBSDKDocumentDataExtractor().run(image: image)
            return ScanResult(title: title,
                              document: result.document,
                              images: [result.croppedImage],
                              extraFields: [ScanResultField(name: "Status", value: result.status.displayText)],
                              rawJSON: result.toJson())
        case .medicalCertificate:
            let parameters = SBSDKMedicalCertificateScanningParameters()
            parameters.shouldCropDocument = true
            let result = try SBSDKMedicalCertificateScanner.create().run(image: image, parameters: parameters)
            return ScanResult(title: title,
                              fields: result.patientInfoBox.fields.map {
                                  ScanResultField(name: "\($0.type)", value: $0.value)
                              },
                              images: [result.croppedImage?.asUIImage].compactMap { $0 },
                              rawJSON: result.toJson())
        case .documentQuality:
            let result = try SBSDKDocumentQualityAnalyzer().run(image: image)
            return ScanResult(title: title,
                              fields: [ScanResultField(name: "Quality", value: result.quality.displayText)])
        }
    }
}

extension SBSDKDocumentQualityAssessment {
    
    var displayText: String {
        switch self {
        case .acceptable: return "Acceptable"
        case .unacceptable: return "Unacceptable"
        case .uncertain: return "Uncertain"
        default: return "\(rawValue)"
        }
    }
}
