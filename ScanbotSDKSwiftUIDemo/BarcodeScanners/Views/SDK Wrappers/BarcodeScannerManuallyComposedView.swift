//
//  BarcodeScannerManuallyComposedView.swift
//  SwiftUIBarcodeSDKShowcase
//
//  Created by Danil Voitenko on 21.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerManuallyComposedView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode

    @Binding private var scanningResult: BarcodeScanningResult

    private let cameraSession: SBSDKCameraSession = SBSDKCameraSession(for: FeatureQRCode)
    private let barcodeScanner: SBSDKBarcodeScanner = SBSDKBarcodeScanner()

    init(scanningResult: Binding<BarcodeScanningResult>) {
        _scanningResult = scanningResult
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraSession.videoDelegate = context.coordinator
        
        return ContainerViewController(cameraSession: cameraSession)
    }
    
    func updateUIViewController(_ uiView: UIViewController, context: Context) { }
}

extension BarcodeScannerManuallyComposedView {
    final class Coordinator: NSObject, SBSDKCameraSessionDelegate {
        
        private var parent: BarcodeScannerManuallyComposedView
        
        init(_ parent: BarcodeScannerManuallyComposedView) {
            self.parent = parent
        }
                
        func captureOutput(_ output: AVCaptureOutput,
                           didOutput sampleBuffer: CMSampleBuffer,
                           from connection: AVCaptureConnection) {
            if let results = parent.barcodeScanner.detectBarCodes(on: sampleBuffer,
                                                    orientation: parent.cameraSession.videoOrientation),
               !results.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if self.parent.presentationMode.wrappedValue.isPresented {
                        self.parent.scanningResult = BarcodeScanningResult(barcodeScannerName: "Manually Built Scanner",
                                                                    scannedBarcodes: results)
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

extension BarcodeScannerManuallyComposedView {
    final class ContainerViewController: UIViewController {
        
        private let cameraSession: SBSDKCameraSession
        
        init(cameraSession: SBSDKCameraSession) {
            self.cameraSession = cameraSession
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            cameraSession.captureSession?.sessionPreset = .photo
            view.layer.addSublayer(cameraSession.previewLayer)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            cameraSession.start()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            cameraSession.stop()
        }
            
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            cameraSession.previewLayer.frame = view.bounds
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            switch orientation {
            case .portrait:
                cameraSession.videoOrientation = .portrait
            case .portraitUpsideDown:
                cameraSession.videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                cameraSession.videoOrientation = .landscapeLeft
            case .landscapeRight:
                cameraSession.videoOrientation = .landscapeRight
            default:
                cameraSession.videoOrientation = .portrait
            }
        }
    }
}
