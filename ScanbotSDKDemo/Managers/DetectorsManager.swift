//
//  DetectorsManager.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

protocol DetectorsManagerDelegate: AnyObject {
    func scanner(_ scanner: SBSDKBarcodeScanner,
                 didFindBarcodes result: [SBSDKBarcodeScannerResult]?)
    
    func recognizer(_ recognizer: SBSDKHealthInsuranceCardRecognizer,
                    didFindEHIC result: SBSDKHealthInsuranceCardRecognitionResult?)
    
    func recognizer(_ recognizer: SBSDKGenericDocumentRecognizer,
                    didFindDocument result: SBSDKGenericDocumentRecognitionResult?)
    
    func recognizer(_ recognizer: SBSDKMachineReadableZoneRecognizer,
                    didFindMRZ result: SBSDKMachineReadableZoneRecognizerResult?)
    
    func recognizer(_ recognizer: SBSDKDisabilityCertificatesRecognizer,
                    didFindMedicalCertificate result: SBSDKDisabilityCertificatesRecognizerResult?)
    
    func scanner(_ scanner: SBSDKLicensePlateScanner,
                 didFindLicensePlate result: SBSDKLicensePlateScannerResult?)
}

final class DetectorsManager {
    enum Detector: CaseIterable {
        case barcode, ehic, genericDocument, mrz, medicalCertificate, licensePlate
        
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
            case .licensePlate:
                return "License Plate"
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
            let result = scanner.detectBarCodes(on: image)
            delegate?.scanner(scanner, didFindBarcodes: result)
        case .ehic:
            let recognizer = SBSDKHealthInsuranceCardRecognizer()
            let result = recognizer.recognize(fromStillImage: image)
            delegate?.recognizer(recognizer, didFindEHIC: result)
        case .genericDocument:
            let recognizer = SBSDKGenericDocumentRecognizer(
                acceptedDocumentTypes: SBSDKGenericDocumentRootType.allDocumentTypes())
            let result = recognizer.recognizeDocument(on: image)
            delegate?.recognizer(recognizer, didFindDocument: result)
        case .mrz:
            let recognizer = SBSDKMachineReadableZoneRecognizer()
            let result = recognizer.recognizePersonalIdentity(from: image)
            delegate?.recognizer(recognizer, didFindMRZ: result)
        case .medicalCertificate:
            let recognizer = SBSDKDisabilityCertificatesRecognizer()
            let result = recognizer.detectAndRecognize(from: image)
            delegate?.recognizer(recognizer, didFindMedicalCertificate: result)
        case .licensePlate:
            let scanner = SBSDKLicensePlateScanner(configuration: SBSDKLicensePlateScannerConfiguration())
            let result = scanner.scanVideoFrameImage(image,
                                                     in: makeFinderRect(for: image))
            delegate?.scanner(scanner, didFindLicensePlate: result)
        }
    }
    
    private func makeFinderRect(for image: UIImage) -> CGRect {
        let width = image.size.width
        let height = image.size.height
        let finderHeight = width / 4
        return CGRect(x: 0, y: (height / 2) - (finderHeight / 2), width: width, height: finderHeight)
    }
}
