//
//  MedicalCertificateScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

import UIKit
import ScanbotSDK

class MedicalCertificateScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKMedicalCertificateScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
        let scanningParameters = SBSDKMedicalCertificateScanningParameters()
        
        // Enable the medical certificate image extraction.
        scanningParameters.extractCroppedImage = true
        
        // Customize the parameters as needed.
        scanningParameters.shouldCropDocument = true
        scanningParameters.recognizePatientInfoBox = true
        scanningParameters.recognizeBarcode = true
        scanningParameters.preprocessInput = false
        
        // Create the `SBSDKMedicalCertificateRecognizerViewController` instance and embed it.
        self.scannerViewController = SBSDKMedicalCertificateScannerViewController(parentViewController: self,
                                                                                  parentView: self.view,
                                                                                  scannerParameters: scanningParameters,
                                                                                  delegate: self)
    }
}

extension MedicalCertificateScannerViewController: SBSDKMedicalCertificateScannerViewControllerDelegate {
    
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didScanMedicalCertificate result: SBSDKMedicalCertificateScanningResult) {
        // Process the scanned result.
        
        // Get the cropped image.
        let croppedImage = try? result.croppedImage?.toUIImage()
    }
    
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning Medical certificate: \(error.localizedDescription)")
    }
}
