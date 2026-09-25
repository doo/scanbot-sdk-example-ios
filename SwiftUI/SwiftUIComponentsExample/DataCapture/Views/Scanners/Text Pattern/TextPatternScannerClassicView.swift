//
//  TextPatternScannerClassicView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the classic text pattern scanner component using the native SwiftUI view `SBSDKScannerView`.
struct TextPatternScannerClassicView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKTextPatternScannerViewModel?
    @StateObject private var state = ScannerSessionState()
    
    var body: some View {
        Group {
            if let model = model {
                // The frame engine publishes its events through a Combine subject,
                // so the view can consume the scanner directly, without any wrapper object.
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
            let model = try SBSDKTextPatternScannerViewModel(scannerConfiguration: Self.configuration())
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    /// Accepts alphanumeric characters, whitespace and punctuation.
    private static func configuration() -> SBSDKTextPatternScannerConfiguration {
        let configuration = SBSDKTextPatternScannerConfiguration()
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.formUnion(.whitespaces)
        characterSet.formUnion(.punctuationCharacters)
        
        let validator = SBSDKContentValidator.customContentValidator()
        validator.allowedCharacters = String(String.UnicodeScalarView(characterSet.scalars))
        configuration.validator = validator
        
        return configuration
    }
    
    private func handle(event: SBSDKFrameEngineEvent<SBSDKTextPatternScannerResult, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _):
            guard result.validationSuccessful && !result.rawText.isEmpty else { return }
            state.present(ScanResult(title: "Text pattern",
                                     fields: [
                                        ScanResultField(name: "Text", value: result.rawText),
                                        ScanResultField(name: "Confidence",
                                                        value: String(format: "%.2f", result.confidence))
                                     ],
                                     rawJSON: result.toJson()))
        case .failure(let error):
            state.present(error: error)
        default:
            break
        }
    }
}

extension CharacterSet {
    
    /// All Unicode scalars contained in the character set.
    var scalars: [Unicode.Scalar] {
        return (UInt32(0)...UInt32(0x10FFFF)).compactMap { Unicode.Scalar($0) }.filter { contains($0) }
    }
}
