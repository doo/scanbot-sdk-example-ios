//
//  DocumentScannerClassicView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

/// Shows the classic document scanner component using the native SwiftUI view `SBSDKScannerView`.
/// The user can capture any number of pages, automatically or manually, and finish the session explicitly.
struct DocumentScannerClassicView: View {
    
    let usesViewFinder: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var scanningResult: DocumentScanningResult
    @Binding var isScanningEnabled: Bool
    
    @State private var model: SBSDKDocumentScannerViewModel?
    @State private var document = SBSDKDocument()
    @State private var capturedPageCount = 0
    @State private var error: ScannerError?
    
    /// The aspect ratio of an A4 page in portrait orientation.
    private let a4AspectRatio = SBSDKAspectRatio(width: 21.0, height: 29.7)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let model = model {
                // The frame engine publishes its events through a Combine subject,
                // so the view can consume the scanner directly, without any wrapper object.
                SBSDKScannerView(model: model)
                    .onScannerEvent(model.frameEngine.events, perform: handle(event:))
            } else {
                Color.black
            }
            
            HStack {
                Button(action: captureManually) {
                    Text("Capture")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                Button(action: finish) {
                    Text("Done (\(capturedPageCount))")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .disabled(capturedPageCount == 0)
            }
            .padding()
        }
        .onAppear(perform: createScannerIfNeeded)
        .onChange(of: isScanningEnabled) { isEnabled in
            model?.baseRuntime.isScanningEnabled = isEnabled
        }
        .alert(item: $error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    private func createScannerIfNeeded() {
        guard model == nil else { return }
        do {
            let model = try SBSDKDocumentScannerViewModel(scannerConfiguration: SBSDKDocumentScannerConfiguration())
            
            // The view finder restricts the scanning to an A4 sized region of interest.
            if usesViewFinder {
                let viewFinder = model.baseConfiguration.viewFinder
                viewFinder.isViewFinderEnabled = true
                viewFinder.aspectRatio = a4AspectRatio
            }
            
            model.baseRuntime.isScanningEnabled = isScanningEnabled
            self.model = model
        } catch {
            self.error = ScannerError(error)
        }
    }
    
    private func handle(event: SBSDKFrameEngineCapturableEvent<SBSDKDocumentDetectionResult?,
                                                               SBSDKImageRef,
                                                               SBSDKImageRef,
                                                               SBSDKDocumentCapturedResultPayload>) {
        switch event {
        case .capturedResult(_, let payload):
            guard let payload = payload else { return }
            add(image: payload.originalImage, polygon: payload.polygon)
        case .failure(let error):
            self.error = ScannerError(error)
        case .everyFrame, .validResult:
            break
        }
    }
    
    /// Triggers a manual capture, using the polygon of the currently detected document.
    private func captureManually() {
        guard let model = model else { return }
        let polygon = model.frameEngine.detectedDocument?.polygon
        model.captureStillImage { image, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = ScannerError(error)
                } else if let image = image {
                    add(image: image, polygon: polygon)
                }
            }
        }
    }
    
    private func add(image: SBSDKImageRef, polygon: SBSDKPolygon?) {
        let page = SBSDKDocumentPage(image: image, polygon: polygon, parametricFilters: .none)
        _ = document.add(page)
        capturedPageCount = document.pages.count
    }
    
    private func finish() {
        guard presentationMode.wrappedValue.isPresented else { return }
        do {
            let scannedDocument = try SBSDKScannedDocument(document: document, documentImageSizeLimit: 0)
            scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
            presentationMode.wrappedValue.dismiss()
        } catch {
            self.error = ScannerError(error)
        }
    }
}
