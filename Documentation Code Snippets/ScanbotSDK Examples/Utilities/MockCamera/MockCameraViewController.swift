//
//  MockCameraViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 31.07.25.
//

import Foundation
import ScanbotSDK

class MockCameraViewController: UIViewController {
    
    var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Launch the scanner.
        launchScanner()
        
        // Configure for camera replay.
        configureMockCamera()
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
        scannerViewController.baseViewModel.camera.startReplay(with: SBSDKCameraMockData(label: "Mock Camera",
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
        // scannerViewController.baseViewModel.camera.startReplay(with: SBSDKCameraMockData(label: "Mock Camera",
        //                                                                                    imageName: imageName,
        //                                                                                    capturedImageName: nil,
        //                                                                                    refreshOnEachFrame: false))
    }
    
    func launchScanner() {
        
        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: view,
                                                                  configuration: .init(),
                                                                  delegate: self)
    }
}

extension MockCameraViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        print("Codes count: \(codes.count)")
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning barcode: \(error.localizedDescription)")
    }
}
