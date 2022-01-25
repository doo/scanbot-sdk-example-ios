//
//  StaticImageDetectionViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 20.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class StaticImageDetectionViewController: UIViewController {
    private enum Segue: String {
        case presentScannerCamera
        case showBarcodeResults
        case showGenericDocumentResult
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var selectImageButton: UIButton!
    @IBOutlet private var selectDetectorButton: UIButton!

    private var importAction: ImportAction?
    private var detectorsManager: DetectorsManager?
    private var alertsManager: AlertsManager?
    
    private var barcodeResults: [SBSDKBarcodeScannerResult]?
    private var genericDocumentResult: SBSDKGenericDocumentRecognitionResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importAction = ImportAction(completionHandler: { [weak self] image in
            self?.imageView.image = image
        })
        detectorsManager = DetectorsManager(delegate: self)
        alertsManager = AlertsManager(presenter: self)
    }
    
    @IBAction private func takePhotoDidPress(_ sender: Any?) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segue.presentScannerCamera.rawValue, sender: self)
        }
        let importImageAction = UIAlertAction(title: "Import an image", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.importAction?.showImagePicker(on: self)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(takePhotoAction)
        alert.addAction(importImageAction)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = selectImageButton
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func selectDetectorDidPress(_ sender: Any?) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        guard let detectorsManager = detectorsManager else { return }
        for detector in detectorsManager.allDetectors {
            let action = UIAlertAction(title: detector.detectorName, style: .default) { [weak self] _ in
                guard let image = self?.imageView.image else { return }
                detectorsManager.detectInfo(on: image, using: detector)
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = selectDetectorButton
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.presentScannerCamera.rawValue {
            if let controller = segue.destination as? ScannerCameraViewController {
                controller.delegate = self
            }
        } else if segue.identifier == Segue.showBarcodeResults.rawValue {
            if let controller = segue.destination as? BarcodeScannerResultsViewController {
                controller.results = barcodeResults
            }
        } else if segue.identifier == Segue.showGenericDocumentResult.rawValue {
            if let controller = segue.destination as? GenericDocumentResultViewController {
                controller.document = genericDocumentResult?.document
            }
        }
    }
}

extension StaticImageDetectionViewController: ScannerCameraViewControllerDelegate {
    func cameraViewController(_ viewController: ScannerCameraViewController, didCapture image: UIImage) {
        imageView.image = image
    }
}

extension StaticImageDetectionViewController: DetectorsManagerDelegate {
    func scanner(_ scanner: SBSDKBarcodeScanner,
                 didFindBarcodes result: [SBSDKBarcodeScannerResult]?) {
        guard let result = result, !result.isEmpty else {
            alertsManager?.showFailureAlert()
            return
        }
        barcodeResults = result
        performSegue(withIdentifier: Segue.showBarcodeResults.rawValue, sender: self)
    }
    
    func recognizer(_ recognizer: SBSDKHealthInsuranceCardRecognizer,
                    didFindEHIC result: SBSDKHealthInsuranceCardRecognitionResult?) {
        guard let result = result,
        result.status == SBSDKHealthInsuranceCardDetectionStatus.success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.stringRepresentation())
    }
    
    func recognizer(_ recognizer: SBSDKGenericDocumentRecognizer,
                    didFindDocument result: SBSDKGenericDocumentRecognitionResult?) {
        guard let result = result else {
            alertsManager?.showFailureAlert()
            return
        }
        genericDocumentResult = result
        performSegue(withIdentifier: Segue.showGenericDocumentResult.rawValue, sender: self)
    }
    
    func recognizer(_ recognizer: SBSDKMachineReadableZoneRecognizer,
                    didFindMRZ result: SBSDKMachineReadableZoneRecognizerResult?) {
        guard let result = result, result.recognitionSuccessful else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.stringRepresentation())
    }
    
    func recognizer(_ recognizer: SBSDKDisabilityCertificatesRecognizer,
                    didFindMedicalCertificate result: SBSDKDisabilityCertificatesRecognizerResult?) {
        guard let result = result, result.recognitionSuccessful else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.stringRepresentation())
    }
    
    func scanner(_ scanner: SBSDKLicensePlateScanner,
                 didFindLicensePlate result: SBSDKLicensePlateScannerResult?) {
        guard let result = result else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.rawString)
    }
}
