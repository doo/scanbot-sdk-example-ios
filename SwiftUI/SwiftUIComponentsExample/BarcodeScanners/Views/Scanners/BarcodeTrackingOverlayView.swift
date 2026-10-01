//
//  BarcodeTrackingOverlayView.swift
//  SwiftUIComponentsExample
//
//  Shows the barcode tracking overlay of the classic barcode scanner, including a custom
//  SwiftUI view that is rendered on top of every tracked barcode.
//

import SwiftUI
import ScanbotSDK

/// The custom SwiftUI view that the tracking overlay renders on top of a tracked barcode.
struct TrackedBarcodeLabel: View {
    
    let barcode: SBSDKBarcodeItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            Text(barcode.format.name)
                .font(.caption2)
            Text(barcode.displayText)
                .font(.caption)
                .bold()
                .lineLimit(1)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .foregroundColor(.white)
        .background(isSelected ? Color.green.opacity(0.9) : Color.black.opacity(0.7))
        .cornerRadius(6)
    }
}

/// Shows the classic barcode scanner with a tracking overlay using the native SwiftUI view `SBSDKScannerView`.
struct BarcodeTrackingOverlayView: View {
    
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKBarcodeScannerViewModel?
    @State private var selectedBarcodes: [SBSDKBarcodeItem] = []
    @StateObject private var state = ScannerSessionState()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let model = model {
                SBSDKScannerView(model: model)
                    .onScannerEvent(model.frameEngine.events) { event in
                        if case .failure(let error) = event { state.present(error: error) }
                    }
            } else {
                Color.black
            }
            
            Button(action: showResults) {
                Text("Show \(selectedBarcodes.count) selected barcodes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding()
            .disabled(selectedBarcodes.isEmpty)
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
            let configuration = SBSDKBarcodeScannerConfiguration()
            configuration.barcodeFormatConfigurations = [SBSDKBarcodeFormatCommonConfiguration()]
            
            let model = try SBSDKBarcodeScannerViewModel(scannerConfiguration: configuration)
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            
            // Enable the tracking overlay and let the user select barcodes by tapping them.
            let overlay = model.trackingOverlay
            let overlayConfiguration = SBSDKBarcodeTrackingOverlayConfiguration()
            overlayConfiguration.selectionMode = .multiple
            overlay.trackingOverlayConfiguration = overlayConfiguration
            overlay.isTrackingOverlayEnabled = true
            
            // Style each tracked barcode depending on its dimensionality.
            overlay.handlers.style = { item, proposedStyle in
                let style = proposedStyle
                let isTwoD = SBSDKBarcodeFormats.twod.contains(item.barcode.format)
                let baseColor: UIColor = isTwoD ? .systemRed : .systemBlue
                
                style.polygonDrawingEnabled = true
                style.cornerRadius = 8
                style.borderWidth = item.isSelected ? 4 : 2
                style.polygonColor = baseColor.withAlphaComponent(0.8)
                style.polygonBackgroundColor = baseColor.withAlphaComponent(item.isSelected ? 0.4 : 0.2)
                
                // The text is drawn by the custom SwiftUI view below.
                style.textDrawingEnabled = false
                
                return style
            }
            
            // The overlay renders a native SwiftUI view on top of every tracked barcode.
            overlay.handlers.customView = { item in
                return AnyView(TrackedBarcodeLabel(barcode: item.barcode, isSelected: item.isSelected))
            }
            
            overlay.handlers.didChangeSelection = { [selection = $selectedBarcodes] barcodes in
                DispatchQueue.main.async { selection.wrappedValue = barcodes }
            }
            
            self.model = model
        } catch {
            state.present(error: error)
        }
    }
    
    private func showResults() {
        let fields = selectedBarcodes.map { barcode in
            ScanResultField(name: barcode.format.name, value: barcode.displayText)
        }
        state.present(ScanResult(title: "Selected barcodes", fields: fields))
    }
}
