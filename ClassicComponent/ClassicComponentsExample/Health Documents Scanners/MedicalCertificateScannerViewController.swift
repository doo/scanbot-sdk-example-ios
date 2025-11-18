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
    private var recognizerViewController: SBSDKMedicalCertificateScannerViewController?
    private var alertsManager: AlertsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizerViewController = SBSDKMedicalCertificateScannerViewController(parentViewController: self,
                                                                                parentView: self.view,
                                                                                scannerParameters: SBSDKMedicalCertificateScanningParameters(),
                                                                                delegate: self)
        
        
        alertsManager = AlertsManager(presenter: self)
    }
    
    private func show(scannedResult: SBSDKMedicalCertificateScanningResult?) {
        recognizerViewController?.isScanningEnabled = false
        if let scannedResult = scannedResult, scannedResult.scanningSuccessful {
            alertsManager?.showSuccessAlert(with: scannedResult.toJson(), completionHandler: {
                self.recognizerViewController?.isScanningEnabled = true
            })
        } else {
            alertsManager?.showFailureAlert(completionHandler: {
                self.recognizerViewController?.isScanningEnabled = true
            })
        }
    }
}

extension MedicalCertificateScannerViewController: SBSDKMedicalCertificateScannerViewControllerDelegate {
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController,
                                                 didScanMedicalCertificate result: SBSDKMedicalCertificateScanningResult) {
        
        if result.scanningSuccessful {
            show(scannedResult: result)
        }
    }
    
    func medicalCertificateScannerViewController(_ controller: SBSDKMedicalCertificateScannerViewController, didFailScanning error: any Error) {
        sbsdk_showError(error)
    }
}
