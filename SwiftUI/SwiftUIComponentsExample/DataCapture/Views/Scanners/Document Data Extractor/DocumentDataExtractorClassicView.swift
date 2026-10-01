//
//  DocumentDataExtractorClassicView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the classic document data extractor using the native SwiftUI view `SBSDKScannerView`.
struct DocumentDataExtractorClassicView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKDocumentDataExtractorViewModel?
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
        .onChange(of: state.result == nil) { hasNoResult in
            // The extractor accumulates data over several frames, so start over
            // once the user dismissed the previous result.
            if hasNoResult { model?.frameEngine.resetAccumulation() }
        }
        .scannerSession(state)
    }
    
    private func createScannerIfNeeded() {
        guard model == nil else { return }
        do {
            let configuration = SBSDKDocumentDataExtractorConfiguration()
            configuration.returnCrops = true
            
            let model = try SBSDKDocumentDataExtractorViewModel(scannerConfiguration: configuration)
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineEvent<SBSDKDocumentDataExtractionResult, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _):
            switch result.status {
            case .ok, .okButInvalidDocument, .okButLowConfidenceResults:
                break
            default:
                return
            }
            guard result.document != nil else { return }
            
            state.present(ScanResult(title: "Document data",
                                     document: result.document,
                                     images: [result.croppedImage],
                                     extraFields: [ScanResultField(name: "Status", value: result.status.displayText)],
                                     rawJSON: result.toJson()))
        case .failure(let error):
            state.present(error: error)
        default:
            break
        }
    }
}

extension SBSDKDocumentDataExtractionStatus {
    
    var displayText: String {
        switch self {
        case .ok:
            return "OK"
        case .okButInvalidDocument:
            return "OK, but invalid document"
        case .okButLowConfidenceResults:
            return "OK, but low confidence results"
        case .scanningInProgressStillFocusing:
            return "Still focusing"
        case .errorNothingFound:
            return "Nothing found"
        default:
            return "\(rawValue)"
        }
    }
}
