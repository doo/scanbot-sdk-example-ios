//
//  CreditCardScannerClassicView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the classic credit card scanner component using the native SwiftUI view `SBSDKScannerView`.
struct CreditCardScannerClassicView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKCreditCardScannerViewModel?
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
            let model = try SBSDKCreditCardScannerViewModel(scannerConfiguration: SBSDKCreditCardScannerConfiguration())
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineEvent<SBSDKCreditCardScanningResult, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _):
            guard result.scanningStatus == .success, let creditCard = result.creditCard else { return }
            state.present(ScanResult(title: "Credit card",
                                     document: creditCard,
                                     rawJSON: result.toJson()))
        case .failure(let error):
            state.present(error: error)
        default:
            break
        }
    }
}
