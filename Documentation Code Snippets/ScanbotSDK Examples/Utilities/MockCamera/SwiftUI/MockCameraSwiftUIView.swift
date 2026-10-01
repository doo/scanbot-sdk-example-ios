//
//  MockCameraSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct MockCameraSwiftUIView: View {
    
    @State private var scannerViewModel = try! SBSDKBarcodeScannerViewModel(scannerConfiguration: .init())
    
    var body: some View {
        // Launch the scanner.
        SBSDKScannerView(model: scannerViewModel)
            .onAppear {
                // Configure for camera replay.
                configureMockCamera()
            }
            .onReceive(scannerViewModel.frameEngine.events) { event in
                switch event {
                case .validResult(let snapshot, _):
                    print("Codes count: \(snapshot.barcodes.count)")
                case .everyFrame:
                    break
                case .failure(let error):
                    // Handle the error.
                    print("Error scanning barcode: \(error.localizedDescription)")
                }
            }
    }
    
    func configureMockCamera() {
        
        // Load Image URL.
        // The URL can be a remote or a local URL.
        guard let imageUrl = Bundle.main.url(forResource: "<image_name>",
                                             withExtension: "<image_extension>") else { return }
        
        // Start replaying the camera feed from an image URL.
        // You can also pass a separate image url for `capturedImageURL` to be used when capturing a still image.
        // Or pass nil for `capturedImageURL` to use the current frame of the `imageURL` when capturing a still image.
        // If `refreshOnEachFrame` is set to `true` the image is reloaded/downloaded after each frame.
        // Otherwise the image is loaded only once and reused per frame.
        scannerViewModel.camera.startReplay(with: SBSDKCameraMockData(label: "Mock Camera",
                                                                      imageURL: imageUrl,
                                                                      capturedImageURL: nil,
                                                                      refreshOnEachFrame: false))
        
        // Alternatively, you can start replaying the camera feed from an image name
        // (e.g. a bundled image file) instead of a URL. Uncomment this and remove
        // the `startReplay(with:)` call above if you'd rather replay by name.
        // You can also pass a separate image name for `capturedImageName` to be used when capturing a still image.
        // Or pass nil for `capturedImageName` to use the current frame of the `imageName` when capturing a still image.
        // If `refreshOnEachFrame` is set to `true` the image is reloaded after each frame.
        // Otherwise the image is loaded only once and reused per frame.
        //
        // let imageName = "<image_name>"
        // scannerViewModel.camera.startReplay(with: SBSDKCameraMockData(label: "Mock Camera",
        //                                                               imageName: imageName,
        //                                                               capturedImageName: nil,
        //                                                               refreshOnEachFrame: false))
    }
}

#Preview {
    MockCameraSwiftUIView()
}
