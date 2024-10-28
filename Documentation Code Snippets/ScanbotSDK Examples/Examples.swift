//
//  Examples.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 23.10.24.
//

import UIKit

enum ExampleCategory: String, CaseIterable {
    
    case barcode = "Barcode"
    case document = "Document"
    case genericDocument = "Generic document"
    case genericTextLine = "Generic text line"
    case license = "License"
    case mrz = "MRZ"
    case ehic = "Ehic"
    case medical = "Medical"
    case check = "Check"
    case vin = "Vin"
    case utilities = "Utilities"
    case imageEditing = "Image editing"
    case filtersImageProcessing = "Filters and image processing"
    
    
    var examples: [UIViewController.Type] {
        
        switch self {
        case .utilities:
            return [SoundControllerViewController.self,
                    ImageStoringViewController.self,
                    DocumentQualityAnalyzerScannedPageViewController.self,
                    DocumentQualityAnalyzerImageViewController.self,
                    TextOrientationRecognizerViewController.self,
                    PDFAttributesViewController.self,
                    ImageMetadataProcessorViewController.self,
                    CameraDeviceViewController.self,
                    ZoomingImageScrollViewViewController.self]
            
            
        case .document:
            return [CropScreenUI2ViewController.self,
                    DocumentLaunchingUI2ViewController.self,
                    DocumentIntroductionUI2ViewController.self,
                    DocumentReviewScreenUI2ViewController.self,
                    DocumentReorderScreenUI2ViewController.self,
                    DocumentPaletteUI2ViewController.self,
                    DocumentLocalizationUI2ViewController.self,
                    DocumentScanningScreenUI2ViewController.self,
                    DocumentSinglePageUI2ViewController.self,
                    DocumentMultiPageUI2ViewController.self,
                    DocumentFinderUI2ViewController.self,
                    DocumentAcknowledgmentUI2ViewController.self,
                    DocumentScannerUIViewController.self,
                    DocumentScannerViewController.self,
                    ScanOnImageCroppingUIViewController.self,
                    DirectDocumentDetectionViewController.self]
        case .imageEditing:
            return [ImageEditingViewController.self]
        case .filtersImageProcessing:
            return [ScannedPageProcessingViewController.self,
                    ImageProcessingViewController.self]
        case .barcode:
            return [BarcodeLocalizationUI2ViewController.self,
                    BarcodePaletteUI2ViewController.self,
                    SingleBarcodeScannerUI2ViewController.self,
                    MultipleBarcodeScannerUI2ViewController.self,
                    FindAndPickBarcodeScannerUI2ViewController.self,
                    AROverlayBarcodeScannerUI2ViewController.self,
                    InfoMappingBarcodeScannerUI2ViewController.self,
                    ActionBarConfigurationUI2ViewController.self,
                    BarcodeUserGuidanceUI2ViewController.self,
                    TopBarBarcodeUI2ViewController.self,
                    BarcodesSheetModeUI2ViewController.self,
                    BarcodeScannerViewController.self,
                    BarcodesBatchViewController.self,
                    BarcodesOverlayViewController.self,
                    BarcodeScanAndCountViewController.self,
                    BarcodeDataParserViewController.self]
        case .genericDocument:
            return [GenericDocumentViewController.self,
                    GenericDocumentUIViewController.self]
        case .genericTextLine:
            return [GenericTextLineScannerViewController.self,
                    GenericTextLineScannerUIViewController.self]
        case .license:
            return [LicensePlateScannerViewController.self,
                    LicensePlateScannerUIViewController.self]
        case .mrz:
            return [MRZScannerViewController.self,
                    MRZScannerUIViewController.self]
        case .ehic:
            return [EHICRecognizerViewController.self,
                    EHICRecognizerUIViewController.self]
        case .medical:
            return [MedicalCertificateRecognizerViewController.self,
                    MedicalCertificateRecognizerUIViewController.self]
        case .check:
            return [CheckRecognizerViewController.self,
                    CheckRecognizerUIViewController.self]
        case .vin:
            return [VINScannerViewController.self,
                    VINScannerUIViewController.self]
        }
    }
}
