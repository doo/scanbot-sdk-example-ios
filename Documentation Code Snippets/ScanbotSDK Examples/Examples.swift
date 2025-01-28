//
//  Examples.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 23.10.24.
//

import UIKit
import SwiftUI

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
    case creditCard = "Credit card"
    case utilities = "Utilities"
    case imageEditing = "Image editing"
    case filtersImageProcessing = "Filters and image processing"
    
    
    var examples: [UIViewController.Type] {
        
        switch self {
        case .utilities:
            return [ClassicUIScannerViewController.self,
                    SoundControllerViewController.self,
                    ImageStoringViewController.self,
                    DocumentQualityAnalyzerScannedPageViewController.self,
                    DocumentQualityAnalyzerImageViewController.self,
                    PDFAttributesViewController.self,
                    ImageMetadataProcessorViewController.self,
                    CameraDeviceViewController.self,
                    ZoomingImageScrollViewViewController.self]
            
            
        case .document:
            return [DocumentSwiftUIHostingViewController.self,
                    CropScreenUI2ViewController.self,
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
            return [BarcodeSwiftUIHostingViewController.self,
                    BarcodeLocalizationUI2ViewController.self,
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
            return [DocumentDataExtractorViewController.self,
                    DocumentDataExtractorUIViewController.self]
        case .genericTextLine:
            return [TextPatternScannerViewController.self,
                    TextPatternScannerUIViewController.self]
        case .license:
            return [LicensePlateScannerViewController.self,
                    LicensePlateScannerUIViewController.self]
        case .mrz:
            return [MRZScannerViewController.self,
                    MRZScannerUIViewController.self,
                    MRZSwiftUIHostingViewController.self,
                    MRZLaunchingUI2ViewController.self,
                    MRZPaletteUI2ViewController.self,
                    MRZLocalizationUI2ViewController.self,
                    MRZIntroductionUI2ViewController.self,
                    MRZUserGuidanceUI2ViewController.self,
                    MRZTopBarUI2ViewController.self,
                    MRZActionBarUI2ViewController.self,
                    MRZFinderOverlayUI2ViewController.self,
                    MRZScanningUI2ViewController.self]
        case .ehic:
            return [EHICExtractorViewController.self,
                    EHICRecognizerUIViewController.self]
        case .medical:
            return [MedicalCertificateScannerViewController.self,
                    MedicalCertificateScannerUIViewController.self]
        case .check:
            return [CheckScannerViewController.self,
                    CheckScannerUIViewController.self]
        case .vin:
            return [VINScannerViewController.self,
                    VINScannerUIViewController.self]
        case .creditCard:
            return [CreditCardScannerViewController.self]
        }
    }
}

@objcMembers class DocumentSwiftUIHostingViewController: UIHostingController<DocumentScannerSwiftUIView> {
    
    init() {
        super.init(rootView: DocumentScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class BarcodeSwiftUIHostingViewController: UIHostingController<BarcodeScannerSwiftUIView> {
    
    init() {
        super.init(rootView: BarcodeScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class MRZSwiftUIHostingViewController: UIHostingController<MRZScannerSwiftUIView> {
    
    init() {
        super.init(rootView: MRZScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
