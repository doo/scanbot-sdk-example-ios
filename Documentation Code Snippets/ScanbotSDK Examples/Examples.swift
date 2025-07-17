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
    case documentData = "Document Data"
    case textPattern = "Text Pattern"
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
                    BarcodeViewFinderUI2ViewController.self,
                    BarcodeGettingStartedUI2ViewController.self,
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
                    BarcodeImageResultHandlingViewController.self,
                    BarcodeRawResultHandlingViewController.self,
                    BarcodeHandlingResultViewController.self,
                    BarcodesBatchViewController.self,
                    BarcodesOverlayViewController.self,
                    BarcodeScanAndCountViewController.self,
                    BarcodeDataParserViewController.self]
        case .documentData:
            return [DocumentDataExtractorSwiftUIHostingViewController.self,
                    DocumentDataExtractorViewController.self,
                    DocumentDataExtractorTopBarUI2ViewController.self,
                    DocumentDataExtractorUserGuidanceUI2ViewController.self,
                    DocumentDataExtractorIntroductionUI2ViewController.self,
                    DocumentDataExtractorLocalizationUI2ViewController.self,
                    DocumentDataExtractorPaletteUI2ViewController.self,
                    DocumentDataExtractorLaunchingUI2ViewController.self,
                    DocumentDataExtractorActionBarUI2ViewController.self,
                    DocumentDataExtractorFinderOverlayUI2ViewController.self,
                    DocumentDataExtractionScreenUI2ViewController.self,]
        case .textPattern:
            return [TextPatternSwiftUIHostingViewController.self,
                    TextPatternScannerViewController.self,
                    TextPatternScannerUIViewController.self,
                    TextPatternLaunchingUI2ViewController.self,
                    TextPatternPaletteUI2ViewController.self,
                    TextPatternLocalizationUI2ViewController.self,
                    TextPatternIntroductionUI2ViewController.self,
                    TextPatternUserGuidanceUI2ViewController.self,
                    TextPatternTopBarUI2ViewController.self,
                    TextPatternActionBarUI2ViewController.self,
                    TextPatternScanningScreenUI2ViewController.self]
        case .mrz:
            return [MRZSwiftUIHostingViewController.self,
                    MRZScannerViewController.self,
                    MRZScannerUIViewController.self,
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
            return [CheckSwiftUIHostingViewController.self,
                    CheckScannerViewController.self,
                    CheckScannerUIViewController.self,
                    CheckTopBarUI2ViewController.self,
                    CheckLaunchingUI2ViewController.self,
                    CheckUserGuidanceUI2ViewController.self,
                    CheckIntroductionUI2ViewController.self,
                    CheckLocalizationUI2ViewController.self,
                    CheckPaletteUI2ViewController.self,
                    CheckActionBarUI2ViewController.self,
                    CheckFinderOverlayUI2ViewController.self,
                    CheckScanningUI2ViewController.self]
        case .vin:
            return [VINSwiftUIHostingViewController.self,
                    VINScannerViewController.self,
                    VINScannerUIViewController.self,
                    VINLaunchingUI2ViewController.self,
                    VINPaletteUI2ViewController.self,
                    VINLocalizationUI2ViewController.self,
                    VINIntroductionUI2ViewController.self,
                    VINUserGuidanceUI2ViewController.self,
                    VINTopBarUI2ViewController.self,
                    VINActionBarUI2ViewController.self,
                    VINScanningScreenUI2ViewController.self]
        case .creditCard:
            return [CreditCardSwiftUIHostingViewController.self,
                    CreditCardScannerViewController.self,
                    CreditCardLaunchingUI2ViewController.self,
                    CreditCardPaletteUI2ViewController.self,
                    CreditCardLocalizationUI2ViewController.self,
                    CreditCardIntroductionUI2ViewController.self,
                    CreditCardUserGuidanceUI2ViewController.self,
                    CreditCardTopBarUI2ViewController.self,
                    CreditCardActionBarUI2ViewController.self,
                    CreditCardFinderOverlayUI2ViewController.self,
                    CreditCardScanningUI2ViewController.self]
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

@objcMembers class CreditCardSwiftUIHostingViewController: UIHostingController<CreditCardScannerSwiftUIView> {
    
    init() {
        super.init(rootView: CreditCardScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class TextPatternSwiftUIHostingViewController: UIHostingController<TextPatternScannerSwiftUIView> {
    
    init() {
        super.init(rootView: TextPatternScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class CheckSwiftUIHostingViewController: UIHostingController<CheckScannerSwiftUIView> {
    
    init() {
        super.init(rootView: CheckScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class VINSwiftUIHostingViewController: UIHostingController<VINScannerSwiftUIView> {
    
    init() {
        super.init(rootView: VINScannerSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers class DocumentDataExtractorSwiftUIHostingViewController: UIHostingController<DocumentDataExtractorSwiftUIView> {
    
    init() {
        super.init(rootView: DocumentDataExtractorSwiftUIView())
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
