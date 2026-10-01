//
//  BarcodeWithTextPatternScannerView.swift
//  SwiftUIComponentsExample
//
//  Combines the text pattern scanner and the barcode scanner using the additional frame processor
//  feature, so that an EAN can be read either from a printed text line or from a barcode.
//

import SwiftUI
import ScanbotSDK

/// Runs a barcode scanner on every camera frame of the text pattern scanner.
///
/// This is the one place where the examples need an object of their own: `SBSDKAdditionalFrameProcessing`
/// is a protocol that the SDK calls back into, so it cannot be satisfied by a SwiftUI view.
final class EANBarcodeFrameProcessor: NSObject, SBSDKAdditionalFrameProcessing {
    
    var shouldProcess: () -> Bool = { true }
    var onEAN: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    private let scanner: SBSDKBarcodeScanner
    private let validator = EANValidator()
    
    init(configuration: SBSDKBarcodeScannerConfiguration = EANBarcodeFrameProcessor.configuration()) throws {
        self.scanner = try SBSDKBarcodeScanner(configuration: configuration)
        super.init()
    }
    
    /// Accepts EAN-8 and EAN-13 codes only.
    static func configuration() -> SBSDKBarcodeScannerConfiguration {
        let configuration = SBSDKBarcodeScannerConfiguration()
        
        // The only allowed format is UpcEan without the UPC codes.
        let eanConfiguration = SBSDKBarcodeFormatUpcEanConfiguration()
        eanConfiguration.ean8 = true
        eanConfiguration.ean13 = true
        eanConfiguration.upca = false
        eanConfiguration.upce = false
        
        // We want to keep the check digits for manual validation.
        eanConfiguration.stripCheckDigits = false
        eanConfiguration.extensions = .ignore
        
        configuration.barcodeFormatConfigurations = [eanConfiguration]
        
        return configuration
    }
    
    func process(frame: SBSDKImageRef) -> Bool {
        guard shouldProcess() else { return false }
        do {
            let result = try scanner.run(image: frame)
            guard let text = result.barcodes.first?.text, validator.isValidEAN(text) else { return true }
            DispatchQueue.main.async { self.onEAN?(text) }
        } catch {
            DispatchQueue.main.async { self.onError?(error) }
        }
        return true
    }
}

/// Shows the combined barcode and text pattern scanner using the native SwiftUI view `SBSDKScannerView`.
struct BarcodeWithTextPatternScannerView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKTextPatternScannerViewModel?
    @State private var frameProcessor: EANBarcodeFrameProcessor?
    @StateObject private var state = ScannerSessionState()
    
    private let validator = EANValidator()
    
    var body: some View {
        Group {
            if let model = model {
                SBSDKScannerView(model: model)
                    .onScannerEvent(model.frameEngine.events, perform: handle(event:))
            } else {
                Color.black
            }
        }
        .onAppear(perform: createScannerIfNeeded)
        .onChange(of: isScanningEnabled) { isEnabled in
            model?.baseRuntime.isScanningEnabled = isEnabled
        }
        .scannerSession(state)
    }
    
    private func createScannerIfNeeded() {
        guard model == nil else { return }
        do {
            let model = try SBSDKTextPatternScannerViewModel(scannerConfiguration: Self.textPatternConfiguration())
            
            // The view finder is sized so that a text line as well as a 1D barcode fit into it.
            let viewFinder = model.baseConfiguration.viewFinder
            viewFinder.aspectRatio = SBSDKAspectRatio(width: 5, height: 1)
            viewFinder.isViewFinderEnabled = true
            viewFinder.preferredHeight = 50
            
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            
            // Every camera frame goes to the text pattern scanner and additionally to the
            // barcode frame processor.
            let frameProcessor = try EANBarcodeFrameProcessor()
            frameProcessor.shouldProcess = { [state] in state.isAcceptingResults }
            frameProcessor.onEAN = { present(value: $0, source: "Barcode") }
            frameProcessor.onError = { state.present(error: $0) }
            model.frameEngine.additionalFrameProcessor = frameProcessor
            
            self.frameProcessor = frameProcessor
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineEvent<SBSDKTextPatternScannerResult, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _):
            guard result.validationSuccessful, validator.isValidEAN(result.rawText) else { return }
            present(value: result.rawText, source: "Text pattern")
        case .failure(let error):
            state.present(error: error)
        case .everyFrame:
            break
        }
    }
    
    private func present(value: String, source: String) {
        state.present(ScanResult(title: "EAN",
                                 fields: [ScanResultField(name: "Value", value: value),
                                          ScanResultField(name: "Scanned via", value: source)]))
    }
    
    private static func textPatternConfiguration() -> SBSDKTextPatternScannerConfiguration {
        let configuration = SBSDKTextPatternScannerConfiguration()
        
        // We want to scan single line text patterns only.
        configuration.optimizeSingleLine = true
        
        // Attach the EAN validator to the text pattern scanner configuration.
        let validator = SBSDKCustomContentValidator()
        validator.allowedCharacters = "0123456789"
        validator.callback = EANValidator()
        configuration.validator = validator
        
        return configuration
    }
}
