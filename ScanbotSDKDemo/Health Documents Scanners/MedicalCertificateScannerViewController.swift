//
//  MedicalCertificateScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class MedicalCertificateScannerViewController: UIViewController {
    private var scannerViewController: SBSDKMedicalCertificateScannerViewController?
    private var alertsManager: AlertsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKMedicalCertificateScannerViewController(parentViewController: self,
                                                                             parentView: nil,
                                                                             device: nil,
                                                                             delegate: self)

        
        alertsManager = AlertsManager(presenter: self)
    }
    
    private func show(recognizedResult: SBSDKMedicalCertificateRecognizerResult?) {
        scannerViewController?.isRecognitionEnabled = false
        if let recognizedResult = recognizedResult, recognizedResult.recognitionSuccessful {
            alertsManager?.showSuccessAlert(with: recognizedResult.stringRepresentation(), completionHandler: {
                self.scannerViewController?.isRecognitionEnabled = true
            })
        } else {
            alertsManager?.showFailureAlert(completionHandler: {
                self.scannerViewController?.isRecognitionEnabled = true
            })
        }
    }
}

extension MedicalCertificateScannerViewController: SBSDKMedicalCertificateScannerViewControllerDelegate {
    
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didRecognizeMedicalCertificate result: SBSDKMedicalCertificateRecognizerResult) {
        
        if result.recognitionSuccessful {
            self.show(recognizedResult: result)
        }
    }
}
