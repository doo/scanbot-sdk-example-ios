//
//  CameraDeviceSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct CameraDeviceSwiftUIView: View {
    
    @State private var scannerDevice: SBSDKCameraDevice?
    
    var body: some View {
        Group {
            if let scannerDevice {
                CameraDeviceScannerView(device: scannerDevice)
            } else {
                Text("Camera Device")
            }
        }
        .task {
            queryCameraDevices()
        }
    }
    
    func queryCameraDevices() {
        
        // Get all the available camera devices.
        let availablesDevices = SBSDKCameraDevice.availableDevices
        
        // Get all the available back camera devices.
        let availablesBackDevices = SBSDKCameraDevice.availableDevices(for: .back)
        
        // Get all the desired cameras by providing the type and position.
        let availableTripeCameraBackDevices = SBSDKCameraDevice.availableDevices(for: .triple, position: .back)
        
        // Get the default back facing camera.
        let defaultBackCamera = SBSDKCameraDevice.defaultBackFacingCamera
        
        // Get the default front facing camera.
        let defaultFrontCamera = SBSDKCameraDevice.defaultFrontFacingCamera
            
        // Get the first triple back camera and create scanner components.
        if let tripleCamera = availableTripeCameraBackDevices.first {
            scannerDevice = tripleCamera
        }  
        
    }
}

private struct CameraDeviceScannerView: UIViewControllerRepresentable {
    
    let device: SBSDKCameraDevice
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        createClassicScanner(with: device, viewController: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func createClassicScanner(with device: SBSDKCameraDevice, viewController: UIViewController) {
        
        // Create the Classic scanner.
        let scanner = SBSDKDocumentScannerViewController(parentViewController: viewController,
                                                         parentView: viewController.view, 
                                                         delegate: nil)
        
        // Assign the device to the scanner.
        scanner?.viewModel.camera.device = device
    }
}

#Preview {
    CameraDeviceSwiftUIView()
}
