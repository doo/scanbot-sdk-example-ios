//
//  CheckScannerClassicView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the classic check scanner component using the native SwiftUI view `SBSDKScannerView`.
struct CheckScannerClassicView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKCheckScannerViewModel?
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
            let model = try SBSDKCheckScannerViewModel(scannerConfiguration: SBSDKCheckScannerConfiguration(),
                                                       captureHighResolutionImage: true)
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineCapturableEvent<SBSDKCheckScanningResult, SBSDKImageRef, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _), .capturedResult(let result, _):
            guard result.status == .success else { return }
            state.present(ScanResult(title: "Check",
                                     document: result.check,
                                     images: [result.croppedImage],
                                     rawJSON: result.toJson()))
        case .failure(let error):
            state.present(error: error)
        default:
            break
        }
    }
}
