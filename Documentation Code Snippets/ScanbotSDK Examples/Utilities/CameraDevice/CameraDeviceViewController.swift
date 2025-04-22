//
//  CameraDeviceViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

import UIKit
import ScanbotSDK

class CameraDeviceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            createClassicScanner(with: tripleCamera)
        }  
        
    }

    func createClassicScanner(with device: SBSDKCameraDevice) {
        
        // Create the Classic scanner.
        let scanner = SBSDKDocumentScannerViewController(parentViewController: self,
                                                         parentView: self.view, 
                                                         delegate: nil)
        
        // Assign the device to the scanner.
        scanner?.cameraDevice = device
    }    
}
