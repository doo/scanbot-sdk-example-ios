//
//  MedicalCertificateScannerView.swift
//  SwiftUIComponentsExample
//
//  The medical certificate scanner is only available as a classic component.
//

import SwiftUI
import ScanbotSDK

/// Shows the classic medical certificate scanner component using the native SwiftUI view `SBSDKScannerView`.
struct MedicalCertificateScannerClassicView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKMedicalCertificateScannerViewModel?
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
            let parameters = SBSDKMedicalCertificateScanningParameters()
            parameters.extractCroppedImage = true
            
            let model = try SBSDKMedicalCertificateScannerViewModel(scannerConfiguration: parameters,
                                                                    captureHighResolutionImage: true)
            // Pause the scanner while a result is being presented.
            model.frameEngine.shouldProcessFrame = { [state] in state.isAcceptingResults }
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineCapturableEvent<SBSDKMedicalCertificateScanningResult, SBSDKImageRef, SBSDKImageRef, SBSDKImageRef>) {
        switch event {
        case .validResult(let result, _), .capturedResult(let result, _):
            guard result.scanningSuccessful else { return }
            
            var fields = result.patientInfoBox.fields.map { ScanResultField(name: "\($0.type)", value: $0.value) }
            fields += result.dates.map { ScanResultField(name: "\($0.type)", value: $0.value) }
            fields += result.checkBoxes.map {
                ScanResultField(name: "\($0.type)", value: $0.checked ? "Checked" : "Not checked")
            }
            
            state.present(ScanResult(title: "Medical certificate",
                                     fields: fields,
                                     images: [result.croppedImage?.asUIImage].compactMap { $0 },
                                     rawJSON: result.toJson()))
        case .failure(let error):
            state.present(error: error)
        default:
            break
        }
    }
}
