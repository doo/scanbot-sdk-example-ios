//
//  BarcodeScanAndCountView.swift
//  SwiftUIComponentsExample
//
//  Scans and counts barcodes. The example intentionally uses the default overlay of the SDK,
//  because the custom overlay provider of the scan and count component is UIKit based.
//

import SwiftUI
import ScanbotSDK

/// Shows the scan and count component using the native SwiftUI view `SBSDKScannerView`.
struct BarcodeScanAndCountView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKBarcodeScanAndCountViewModel?
    @State private var countedBarcodes: [SBSDKBarcodeScannerAccumulatingResult] = []
    @StateObject private var state = ScannerSessionState()
    
    private var totalCount: Int {
        return countedBarcodes.reduce(0) { $0 + $1.scanCount }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let model = model {
                SBSDKScannerView(model: model)
                    // The component accumulates the counted barcodes for us and publishes them,
                    // so the view can observe them directly.
                    .onScannerEvent(model.frameEngine.$accumulatedBarcodes) { countedBarcodes = $0 }
                    .onScannerEvent(model.frameEngine.events) { event in
                        if case .failure(let error) = event { state.present(error: error) }
                    }
            } else {
                Color.black
            }
            
            HStack {
                Button(action: showResults) {
                    Text("Counted: \(totalCount)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .disabled(countedBarcodes.isEmpty)
                
                Button(action: clear) {
                    Text("Clear")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            .padding()
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
            let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: SBSDKBarcodeFormats.all)
            let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
            
            let model = try SBSDKBarcodeScanAndCountViewModel(scannerConfiguration: configuration)
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func clear() {
        model?.frameEngine.clearCountedBarcodes()
        countedBarcodes = []
    }
    
    private func showResults() {
        let fields = countedBarcodes.map { result in
            ScanResultField(name: "\(result.item.format.name) (\(result.scanCount)x)",
                            value: result.item.displayText)
        }
        state.present(ScanResult(title: "Counted barcodes", fields: fields))
    }
}
