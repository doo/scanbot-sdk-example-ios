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
                    ExampleHostingViewController<ClassicUIScannerSwiftUIView>.self,
                    BarcodeClassicUIGeneralConfigurationViewController.self,
                    ExampleHostingViewController<BarcodeClassicUIGeneralConfigurationSwiftUIView>.self,
                    SoundControllerViewController.self,
                    ExampleHostingViewController<SoundControllerSwiftUIView>.self,
                    ImageStoringViewController.self,
                    ExampleHostingViewController<ImageStoringSwiftUIView>.self,
                    DocumentQualityAnalyzerScannedPageViewController.self,
                    ExampleHostingViewController<DocumentQualityAnalyzerScannedPageSwiftUIView>.self,
                    DocumentQualityAnalyzerImageViewController.self,
                    ExampleHostingViewController<DocumentQualityAnalyzerImageSwiftUIView>.self,
                    ImageEnhancerFromImageViewController.self,
                    ExampleHostingViewController<ImageEnhancerFromImageSwiftUIView>.self,
                    ImageEnhancerFromScannedPageViewController.self,
                    ExampleHostingViewController<ImageEnhancerFromScannedPageSwiftUIView>.self,
                    PDFAttributesViewController.self,
                    ExampleHostingViewController<PDFAttributesSwiftUIView>.self,
                    ImageMetadataProcessorViewController.self,
                    ExampleHostingViewController<ImageMetadataProcessorSwiftUIView>.self,
                    CameraDeviceViewController.self,
                    ExampleHostingViewController<CameraDeviceSwiftUIView>.self,
                    ZoomingImageScrollViewViewController.self,
                    MockCameraViewController.self,
                    ExampleHostingViewController<MockCameraSwiftUIView>.self]
            
            
        case .document:
            return [DocumentScannerCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<DocumentScannerSwiftUIView>.self,
                    CropScreenUI2ViewController.self,
                    ExampleHostingViewController<CropScreenUI2SwiftUIView>.self,
                    DocumentLaunchingUI2ViewController.self,
                    ExampleHostingViewController<DocumentLaunchingUI2SwiftUIView>.self,
                    DocumentIntroductionUI2ViewController.self,
                    ExampleHostingViewController<DocumentIntroductionUI2SwiftUIView>.self,
                    DocumentPreviewModesUI2ViewController.self,
                    ExampleHostingViewController<DocumentPreviewModesUI2SwiftUIView>.self,
                    DocumentReviewScreenUI2ViewController.self,
                    ExampleHostingViewController<DocumentReviewScreenUI2SwiftUIView>.self,
                    DocumentReorderScreenUI2ViewController.self,
                    ExampleHostingViewController<DocumentReorderScreenUI2SwiftUIView>.self,
                    DocumentPaletteUI2ViewController.self,
                    ExampleHostingViewController<DocumentPaletteUI2SwiftUIView>.self,
                    DocumentLocalizationUI2ViewController.self,
                    ExampleHostingViewController<DocumentLocalizationUI2SwiftUIView>.self,
                    DocumentScanningScreenUI2ViewController.self,
                    ExampleHostingViewController<DocumentScanningScreenUI2SwiftUIView>.self,
                    DocumentSinglePageUI2ViewController.self,
                    ExampleHostingViewController<DocumentSinglePageUI2SwiftUIView>.self,
                    DocumentMultiPageUI2ViewController.self,
                    ExampleHostingViewController<DocumentMultiPageUI2SwiftUIView>.self,
                    DocumentFinderUI2ViewController.self,
                    ExampleHostingViewController<DocumentFinderUI2SwiftUIView>.self,
                    DocumentAcknowledgmentUI2ViewController.self,
                    ExampleHostingViewController<DocumentAcknowledgmentUI2SwiftUIView>.self,
                    DocumentImageStraighteningUI2ViewController.self,
                    ExampleHostingViewController<DocumentImageStraighteningUI2SwiftUIView>.self,
                    DocumentCleanupUI2ViewController.self,
                    ExampleHostingViewController<DocumentCleanupUI2SwiftUIView>.self,
                    DocumentCleanupScreenUI2ViewController.self,
                    ExampleHostingViewController<DocumentCleanupScreenUI2SwiftUIView>.self,
                    DocumentCleanupCustomUIViewController.self,
                    ExampleHostingViewController<DocumentCleanupCustomUISwiftUIView>.self,
                    DocumentScannerViewController.self,
                    ExampleHostingViewController<DocumentScannerSwiftUIScannerView>.self,
                    ScanOnImageCroppingUIViewController.self,
                    ExampleHostingViewController<ScanOnImageCroppingUISwiftUIView>.self,
                    DirectDocumentDetectionViewController.self,
                    ExampleHostingViewController<DirectDocumentDetectionSwiftUIView>.self]
        case .imageEditing:
            return [ImageEditingViewController.self,
                    ExampleHostingViewController<ImageEditingSwiftUIView>.self]
        case .filtersImageProcessing:
            return [ScannedPageProcessingViewController.self,
                    ExampleHostingViewController<ScannedPageProcessingSwiftUIView>.self,
                    ImageProcessingViewController.self,
                    ExampleHostingViewController<ImageProcessingSwiftUIView>.self]
        case .barcode:
            return [BarcodeScannerCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<BarcodeScannerSwiftUIView>.self,
                    BarcodeLocalizationUI2ViewController.self,
                    ExampleHostingViewController<BarcodeLocalizationUI2SwiftUIView>.self,
                    BarcodeGettingStartedUI2ViewController.self,
                    ExampleHostingViewController<BarcodeGettingStartedUI2SwiftUIView>.self,
                    BarcodeViewFinderUI2ViewController.self,
                    ExampleHostingViewController<BarcodeViewFinderUI2SwiftUIView>.self,
                    BarcodePaletteUI2ViewController.self,
                    ExampleHostingViewController<BarcodePaletteUI2SwiftUIView>.self,
                    SingleBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<SingleBarcodeScannerUI2SwiftUIView>.self,
                    MultipleBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<MultipleBarcodeScannerUI2SwiftUIView>.self,
                    FindAndPickBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<FindAndPickBarcodeScannerUI2SwiftUIView>.self,
                    AROverlayBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<AROverlayBarcodeScannerUI2SwiftUIView>.self,
                    InfoMappingBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<InfoMappingBarcodeScannerUI2SwiftUIView>.self,
                    ActionBarConfigurationUI2ViewController.self,
                    ExampleHostingViewController<ActionBarConfigurationUI2SwiftUIView>.self,
                    BarcodeUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<BarcodeUserGuidanceUI2SwiftUIView>.self,
                    TopBarBarcodeUI2ViewController.self,
                    ExampleHostingViewController<TopBarBarcodeUI2SwiftUIView>.self,
                    TinyBarcodeScannerUI2ViewController.self,
                    ExampleHostingViewController<TinyBarcodeScannerUI2SwiftUIView>.self,
                    BarcodesSheetModeUI2ViewController.self,
                    ExampleHostingViewController<BarcodesSheetModeUI2SwiftUIView>.self,
                    BarcodeScannerViewController.self,
                    ExampleHostingViewController<BarcodeScannerSwiftUIScannerView>.self,
                    BarcodesBatchViewController.self,
                    ExampleHostingViewController<BarcodesBatchSwiftUIView>.self,
                    BarcodesOverlayViewController.self,
                    ExampleHostingViewController<BarcodesOverlaySwiftUIView>.self,
                    BarcodeScanAndCountViewController.self,
                    ExampleHostingViewController<BarcodeScanAndCountSwiftUIView>.self,
                    BarcodeDataParserViewController.self,
                    ExampleHostingViewController<BarcodeDataParserSwiftUIView>.self,
                    BarcodeHandlingResultViewController.self,
                    ExampleHostingViewController<BarcodeHandlingResultSwiftUIView>.self,
                    BarcodeImageResultHandlingViewController.self,
                    ExampleHostingViewController<BarcodeImageResultHandlingSwiftUIView>.self,
                    BarcodeRawResultHandlingViewController.self,
                    ExampleHostingViewController<BarcodeRawResultHandlingSwiftUIView>.self]
        case .documentData:
            return [DocumentDataExtractorCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorSwiftUIView>.self,
                    DocumentDataExtractorViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorSwiftUIScannerView>.self,
                    DocumentDataExtractorTopBarUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorTopBarUI2SwiftUIView>.self,
                    DocumentDataExtractorUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorUserGuidanceUI2SwiftUIView>.self,
                    DocumentDataExtractorIntroductionUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorIntroductionUI2SwiftUIView>.self,
                    DocumentDataExtractorLocalizationUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorLocalizationUI2SwiftUIView>.self,
                    DocumentDataExtractorPaletteUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorPaletteUI2SwiftUIView>.self,
                    DocumentDataExtractorLaunchingUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorLaunchingUI2SwiftUIView>.self,
                    DocumentDataExtractorActionBarUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorActionBarUI2SwiftUIView>.self,
                    DocumentDataExtractorFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractorFinderOverlayUI2SwiftUIView>.self,
                    DocumentDataExtractionScreenUI2ViewController.self,
                    ExampleHostingViewController<DocumentDataExtractionScreenUI2SwiftUIView>.self]
        case .textPattern:
            return [TextPatternScannerCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<TextPatternScannerSwiftUIView>.self,
                    TextPatternScannerViewController.self,
                    ExampleHostingViewController<TextPatternScannerSwiftUIScannerView>.self,
                    TextPatternLaunchingUI2ViewController.self,
                    ExampleHostingViewController<TextPatternLaunchingUI2SwiftUIView>.self,
                    TextPatternFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<TextPatternFinderOverlayUI2SwiftUIView>.self,
                    TextPatternPaletteUI2ViewController.self,
                    ExampleHostingViewController<TextPatternPaletteUI2SwiftUIView>.self,
                    TextPatternLocalizationUI2ViewController.self,
                    ExampleHostingViewController<TextPatternLocalizationUI2SwiftUIView>.self,
                    TextPatternIntroductionUI2ViewController.self,
                    ExampleHostingViewController<TextPatternIntroductionUI2SwiftUIView>.self,
                    TextPatternUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<TextPatternUserGuidanceUI2SwiftUIView>.self,
                    TextPatternTopBarUI2ViewController.self,
                    ExampleHostingViewController<TextPatternTopBarUI2SwiftUIView>.self,
                    TextPatternActionBarUI2ViewController.self,
                    ExampleHostingViewController<TextPatternActionBarUI2SwiftUIView>.self,
                    TextPatternScanningScreenUI2ViewController.self,
                    ExampleHostingViewController<TextPatternScanningScreenUI2SwiftUIView>.self]
        case .mrz:
            return [MRZCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<MRZScannerSwiftUIView>.self,
                    MRZScannerViewController.self,
                    ExampleHostingViewController<MRZScannerSwiftUIScannerView>.self,
                    MRZLaunchingUI2ViewController.self,
                    ExampleHostingViewController<MRZLaunchingUI2SwiftUIView>.self,
                    MRZPaletteUI2ViewController.self,
                    ExampleHostingViewController<MRZPaletteUI2SwiftUIView>.self,
                    MRZLocalizationUI2ViewController.self,
                    ExampleHostingViewController<MRZLocalizationUI2SwiftUIView>.self,
                    MRZIntroductionUI2ViewController.self,
                    ExampleHostingViewController<MRZIntroductionUI2SwiftUIView>.self,
                    MRZUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<MRZUserGuidanceUI2SwiftUIView>.self,
                    MRZTopBarUI2ViewController.self,
                    ExampleHostingViewController<MRZTopBarUI2SwiftUIView>.self,
                    MRZActionBarUI2ViewController.self,
                    ExampleHostingViewController<MRZActionBarUI2SwiftUIView>.self,
                    MRZFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<MRZFinderOverlayUI2SwiftUIView>.self,
                    MRZScanningUI2ViewController.self,
                    ExampleHostingViewController<MRZScanningScreenUI2SwiftUIView>.self]
        case .ehic:
            return [EHICExtractorViewController.self,
                    ExampleHostingViewController<EHICExtractorSwiftUIView>.self]
        case .medical:
            return [MedicalCertificateScannerViewController.self,
                    ExampleHostingViewController<MedicalCertificateScannerSwiftUIScannerView>.self]
        case .check:
            return [CheckCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<CheckScannerSwiftUIView>.self,
                    CheckScannerViewController.self,
                    ExampleHostingViewController<CheckScannerSwiftUIScannerView>.self,
                    CheckTopBarUI2ViewController.self,
                    ExampleHostingViewController<CheckTopBarUI2SwiftUIView>.self,
                    CheckLaunchingUI2ViewController.self,
                    ExampleHostingViewController<CheckLaunchingUI2SwiftUIView>.self,
                    CheckUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<CheckUserGuidanceUI2SwiftUIView>.self,
                    CheckIntroductionUI2ViewController.self,
                    ExampleHostingViewController<CheckIntroductionUI2SwiftUIView>.self,
                    CheckLocalizationUI2ViewController.self,
                    ExampleHostingViewController<CheckLocalizationUI2SwiftUIView>.self,
                    CheckPaletteUI2ViewController.self,
                    ExampleHostingViewController<CheckPaletteUI2SwiftUIView>.self,
                    CheckActionBarUI2ViewController.self,
                    ExampleHostingViewController<CheckActionBarUI2SwiftUIView>.self,
                    CheckFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<CheckFinderOverlayUI2SwiftUIView>.self,
                    CheckScanningUI2ViewController.self,
                    ExampleHostingViewController<CheckScanningUI2SwiftUIView>.self]
        case .vin:
            return [VINCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<VINScannerSwiftUIView>.self,
                    VINScannerViewController.self,
                    ExampleHostingViewController<VINScannerSwiftUIScannerView>.self,
                    VINLaunchingUI2ViewController.self,
                    ExampleHostingViewController<VINLaunchingUI2SwiftUIView>.self,
                    VINPaletteUI2ViewController.self,
                    ExampleHostingViewController<VINPaletteUI2SwiftUIView>.self,
                    VINLocalizationUI2ViewController.self,
                    ExampleHostingViewController<VINLocalizationUI2SwiftUIView>.self,
                    VINIntroductionUI2ViewController.self,
                    ExampleHostingViewController<VINIntroductionUI2SwiftUIView>.self,
                    VINUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<VINUserGuidanceUI2SwiftUIView>.self,
                    VINTopBarUI2ViewController.self,
                    ExampleHostingViewController<VINTopBarUI2SwiftUIView>.self,
                    VINActionBarUI2ViewController.self,
                    ExampleHostingViewController<VINActionBarUI2SwiftUIView>.self,
                    VINScanningScreenUI2ViewController.self,
                    ExampleHostingViewController<VINScanningScreenUI2SwiftUIView>.self,
                    VINFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<VINFinderOverlayUI2SwiftUIView>.self]
        case .creditCard:
            return [CreditCardScannerCustomConfigurationUI2ViewController.self,
                    ExampleHostingViewController<CreditCardScannerSwiftUIView>.self,
                    CreditCardScannerViewController.self,
                    ExampleHostingViewController<CreditCardScannerSwiftUIScannerView>.self,
                    CreditCardLaunchingUI2ViewController.self,
                    ExampleHostingViewController<CreditCardLaunchingUI2SwiftUIView>.self,
                    CreditCardPaletteUI2ViewController.self,
                    ExampleHostingViewController<CreditCardPaletteUI2SwiftUIView>.self,
                    CreditCardLocalizationUI2ViewController.self,
                    ExampleHostingViewController<CreditCardLocalizationUI2SwiftUIView>.self,
                    CreditCardIntroductionUI2ViewController.self,
                    ExampleHostingViewController<CreditCardIntroductionUI2SwiftUIView>.self,
                    CreditCardUserGuidanceUI2ViewController.self,
                    ExampleHostingViewController<CreditCardUserGuidanceUI2SwiftUIView>.self,
                    CreditCardTopBarUI2ViewController.self,
                    ExampleHostingViewController<CreditCardTopBarUI2SwiftUIView>.self,
                    CreditCardActionBarUI2ViewController.self,
                    ExampleHostingViewController<CreditCardActionBarUI2SwiftUIView>.self,
                    CreditCardFinderOverlayUI2ViewController.self,
                    ExampleHostingViewController<CreditCardFinderOverlayUI2SwiftUIView>.self,
                    CreditCardScanningUI2ViewController.self,
                    ExampleHostingViewController<CreditCardScanningUI2SwiftUIView>.self]
        }
    }
}

protocol ExampleSwiftUIView: View {
    init()
}

class ExampleHostingViewController<V: ExampleSwiftUIView>: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: V())
        self.addChild(hostingController)
        hostingController.view.frame = self.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

extension AROverlayBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension ActionBarConfigurationUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodeClassicUIGeneralConfigurationSwiftUIView: ExampleSwiftUIView {}
extension BarcodeDataParserSwiftUIView: ExampleSwiftUIView {}
extension BarcodeGettingStartedUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodeHandlingResultSwiftUIView: ExampleSwiftUIView {}
extension BarcodeImageResultHandlingSwiftUIView: ExampleSwiftUIView {}
extension BarcodeLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodePaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodeRawResultHandlingSwiftUIView: ExampleSwiftUIView {}
extension BarcodeScanAndCountSwiftUIView: ExampleSwiftUIView {}
extension BarcodeScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension BarcodeScannerSwiftUIView: ExampleSwiftUIView {}
extension BarcodeUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodeViewFinderUI2SwiftUIView: ExampleSwiftUIView {}
extension BarcodesBatchSwiftUIView: ExampleSwiftUIView {}
extension BarcodesOverlaySwiftUIView: ExampleSwiftUIView {}
extension BarcodesSheetModeUI2SwiftUIView: ExampleSwiftUIView {}
extension CameraDeviceSwiftUIView: ExampleSwiftUIView {}
extension CheckActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension CheckScannerSwiftUIView: ExampleSwiftUIView {}
extension CheckScanningUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension CheckUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension ClassicUIScannerSwiftUIView: ExampleSwiftUIView {}
extension CreditCardActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension CreditCardScannerSwiftUIView: ExampleSwiftUIView {}
extension CreditCardScanningUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension CreditCardUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension CropScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension CroppingMigrationSwiftUIView: ExampleSwiftUIView {}
extension DirectDocumentDetectionSwiftUIView: ExampleSwiftUIView {}
extension DocumentAcknowledgmentUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentCleanupCustomUISwiftUIView: ExampleSwiftUIView {}
extension DocumentCleanupScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentCleanupUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractionScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorSwiftUIScannerView: ExampleSwiftUIView {}
extension DocumentDataExtractorSwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentDataExtractorUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentFinderUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentImageStraighteningUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentMultiPageUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentPreviewModesUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentQualityAnalyzerImageSwiftUIView: ExampleSwiftUIView {}
extension DocumentQualityAnalyzerScannedPageSwiftUIView: ExampleSwiftUIView {}
extension DocumentReorderScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentReviewScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentScannerMigrationSwiftUIView: ExampleSwiftUIView {}
extension DocumentScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension DocumentScannerSwiftUIView: ExampleSwiftUIView {}
extension DocumentScanningScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension DocumentSinglePageUI2SwiftUIView: ExampleSwiftUIView {}
extension EHICExtractorSwiftUIView: ExampleSwiftUIView {}
extension FindAndPickBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension ImageEditingSwiftUIView: ExampleSwiftUIView {}
extension ImageEnhancerFromImageSwiftUIView: ExampleSwiftUIView {}
extension ImageEnhancerFromScannedPageSwiftUIView: ExampleSwiftUIView {}
extension ImageMetadataProcessorSwiftUIView: ExampleSwiftUIView {}
extension ImageProcessingSwiftUIView: ExampleSwiftUIView {}
extension ImageStoringSwiftUIView: ExampleSwiftUIView {}
extension InfoMappingBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension MRZScannerSwiftUIView: ExampleSwiftUIView {}
extension MRZScanningScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension MRZUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension MedicalCertificateScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension MockCameraSwiftUIView: ExampleSwiftUIView {}
extension MultipleBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension PDFAttributesSwiftUIView: ExampleSwiftUIView {}
extension ScanAndCountBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension ScanOnImageCroppingUISwiftUIView: ExampleSwiftUIView {}
extension ScannedPageProcessingSwiftUIView: ExampleSwiftUIView {}
extension SingleBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension SoundControllerSwiftUIView: ExampleSwiftUIView {}
extension TextPatternActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension TextPatternScannerSwiftUIView: ExampleSwiftUIView {}
extension TextPatternScanningScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension TextPatternUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
extension TinyBarcodeScannerUI2SwiftUIView: ExampleSwiftUIView {}
extension TopBarBarcodeUI2SwiftUIView: ExampleSwiftUIView {}
extension VINActionBarUI2SwiftUIView: ExampleSwiftUIView {}
extension VINFinderOverlayUI2SwiftUIView: ExampleSwiftUIView {}
extension VINIntroductionUI2SwiftUIView: ExampleSwiftUIView {}
extension VINLaunchingUI2SwiftUIView: ExampleSwiftUIView {}
extension VINLocalizationUI2SwiftUIView: ExampleSwiftUIView {}
extension VINPaletteUI2SwiftUIView: ExampleSwiftUIView {}
extension VINScannerSwiftUIScannerView: ExampleSwiftUIView {}
extension VINScannerSwiftUIView: ExampleSwiftUIView {}
extension VINScanningScreenUI2SwiftUIView: ExampleSwiftUIView {}
extension VINTopBarUI2SwiftUIView: ExampleSwiftUIView {}
extension VINUserGuidanceUI2SwiftUIView: ExampleSwiftUIView {}
