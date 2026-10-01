//
//  BarcodeScannerClassicView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 20.07.21.
//

import SwiftUI
import ScanbotSDK

/// Shows the classic barcode scanner component using the native SwiftUI view `SBSDKScannerView`,
/// optionally restricted to a view finder.
struct BarcodeScannerClassicView: View {
    
    let usesViewFinder: Bool
    let scannerName: String
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var scanningResult: BarcodeScanningResult
    @Binding var isScanningEnabled: Bool
    @Binding var selectedBarcode: SBSDKBarcodeItem?
    
    @State private var model: SBSDKBarcodeScannerViewModel?
    
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
    }
    
    private func createScannerIfNeeded() {
        guard model == nil else { return }
        do {
            let configuration = SBSDKBarcodeScannerConfiguration()
            configuration.returnBarcodeImage = true
            
            let model = try SBSDKBarcodeScannerViewModel(scannerConfiguration: configuration)
            
            // The view finder restricts the scanning to a region of interest.
            if usesViewFinder {
                let viewFinder = model.baseConfiguration.viewFinder
                viewFinder.lineColor = .green
                viewFinder.lineWidth = 5
                viewFinder.aspectRatio = SBSDKAspectRatio(width: 2, height: 1)
                viewFinder.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
                viewFinder.isViewFinderEnabled = true
            }
            
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            finish(barcodes: nil, error: error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineEvent<SBSDKBarcodeScannerResult,
                                                     SBSDKImageRef,
                                                     SBSDKBarcodeValidResultPayload>) {
        switch event {
        case .validResult(let result, _):
            finish(barcodes: result.barcodes, error: nil)
        case .failure(let error):
            finish(barcodes: nil, error: error)
        case .everyFrame:
            break
        }
    }
    
    private func finish(barcodes: [SBSDKBarcodeItem]?, error: Error?) {
        guard presentationMode.wrappedValue.isPresented else { return }
        if let barcodes = barcodes {
            scanningResult = BarcodeScanningResult(barcodeScannerName: scannerName, scannedItems: barcodes)
        } else if let error = error {
            scanningResult = BarcodeScanningResult(barcodeScannerName: scannerName, error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
