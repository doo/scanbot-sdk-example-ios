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
        
        // Get all the availables camera devices.
        let availablesDevices = SBSDKCameraDevice.availableDevices
        
        // Get all the availables back camera devices.
        let availablesBackDevices = SBSDKCameraDevice.availableDevices(for: .back)
        
        // Get all the desired camera by providing the type and position. 
        let availableTripeCameraBackDevices = SBSDKCameraDevice.availableDevices(for: .triple, position: .back)
        
        // Get the default back facing camera.
        let defaultBackCamera = SBSDKCameraDevice.defaultBackFacingCamera
        
        // Get the default front facing camera.  
        let defaultFrontCamera = SBSDKCameraDevice.defaultFrontFacingCamera
            
        // Get the first triple back camera and create scanner components.
        if let tripleCamera = availableTripeCameraBackDevices.first {
            createRTUUIScanner(with: tripleCamera)
            createClassicalScanner(with: tripleCamera)
        }  
        
    }
    
    func createRTUUIScanner(with device: SBSDKCameraDevice) {
        
        // Create the camera configuration.
        let cameraConfig = SBSDKUICameraConfiguration()
        
        // Assign the device to the camera configuration.
        cameraConfig.camera = device
        
        // Assemble the scanner configuration and pass the camera configuration.
        let configuration = 
        SBSDKUIDocumentScannerConfiguration(uiConfiguration: SBSDKUIDocumentScannerUIConfiguration(), 
                                            textConfiguration: SBSDKUIDocumentScannerTextConfiguration(),
                                            behaviorConfiguration: SBSDKUIDocumentScannerBehaviorConfiguration(), 
                                            cameraConfiguration: cameraConfig)
        
        // Create the RTU-UI scanner, passing the scanner configuration.
        let scanner = SBSDKUIDocumentScannerViewController.createNew(configuration: configuration, delegate: nil)
        
    }


    func createClassicalScanner(with device: SBSDKCameraDevice) {
        
        // Create the classical scanner.
        let scanner = SBSDKDocumentScannerViewController(parentViewController: self, 
                                                         parentView: self.view, 
                                                         delegate: nil)
        
        // Assign the device to the scanner. 
        scanner?.cameraDevice = device
    }    
}
