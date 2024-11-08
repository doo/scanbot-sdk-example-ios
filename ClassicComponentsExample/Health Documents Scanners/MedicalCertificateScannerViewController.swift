//
//  MedicalCertificateScannerViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 30.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class MedicalCertificateScannerViewController: UIViewController {
    private var recognizerViewController: SBSDKMedicalCertificateRecognizerViewController?
    private var alertsManager: AlertsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizerViewController = SBSDKMedicalCertificateRecognizerViewController(parentViewController: self,
                                                                                   parentView: self.view,
                                                                                   recognitionParameters: SBSDKMedicalCertificateRecognitionParameters(),
                                                                                   delegate: self)

        
        alertsManager = AlertsManager(presenter: self)
    }
    
    private func show(recognizedResult: SBSDKMedicalCertificateRecognitionResult?) {
        recognizerViewController?.isRecognitionEnabled = false
        if let recognizedResult = recognizedResult, recognizedResult.recognitionSuccessful {
            alertsManager?.showSuccessAlert(with: recognizedResult.toJson(), completionHandler: {
                self.recognizerViewController?.isRecognitionEnabled = true
            })
        } else {
            alertsManager?.showFailureAlert(completionHandler: {
                self.recognizerViewController?.isRecognitionEnabled = true
            })
        }
    }
}

extension MedicalCertificateScannerViewController: SBSDKMedicalCertificateRecognizerViewControllerDelegate {
    func medicalCertificateRecognizerViewController(_ controller: SBSDKMedicalCertificateRecognizerViewController,
                                                    didRecognizeMedicalCertificate result: SBSDKMedicalCertificateRecognitionResult) {
        
        if result.recognitionSuccessful {
            self.show(recognizedResult: result)
        }
    }
}
