//
//  MockCameraViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 31.07.25.
//

import Foundation
import ScanbotSDK

class MockCameraViewController: UIViewController {
    
    var scannerViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure for mock camera.
        configureMockCamera()
        
        // Launch the scanner.
        launchScanner()
    }
    
    func configureMockCamera() {
        
        // Load Image URL.
        // The URL can be a remote or a local URL.
        guard let imageUrl = Bundle.main.url(forResource: "<image_name>",
                                             withExtension: "<image_extension>") else { return }
        
        // Set mock data for the camera by passing the Image URL.
        // You can also pass a separate image url for `capturedImageUrl` to be used when capturing a still image.
        // Or pass nil for `capturedImageUrl` to use the current frame of the `imageUrl` when capturing a still image.
        // If `refreshOnEachFrame` is set to `true` the image is reloaded/downloaded after each frame.
        // Otherwise the image is loaded only once and reused per frame.
        Scanbot.testData.cameraMockData = SBSDKSimulatedCameraMockData(label: "Mock Camera",
                                                                       imageURL: imageUrl,
                                                                       capturedImageURL: nil,
                                                                       refreshOnEachFrame: false)
        
        // Set mock data for the camera by passing the Image name.
        // You can also pass a separate image name for `capturedImageName` to be used when capturing a still image.
        // Or pass nil for `capturedImageName` to use the current frame of the `imageName` when capturing a still image.
        // If `refreshOnEachFrame` is set to `true` the image is reloaded after each frame.
        // Otherwise the image is loaded only once and reused per frame.
        let imageName = "<image_name>"
        Scanbot.testData.cameraMockData = SBSDKSimulatedCameraMockData(label: "Mock Camera",
                                                                       imageName: imageName,
                                                                       capturedImageName: nil,
                                                                       refreshOnEachFrame: false)
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
}
