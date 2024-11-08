//
//  StaticImageDetectionViewController.swift
//  ClassicComponentsExample
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
    @IBOutlet private var importPhotoButton: UIButton!
    @IBOutlet private var selectDetectorButton: UIButton!

    private var image: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    private var importAction: ImportAction?
    private var detectorsManager: DetectorsManager?
    private var alertsManager: AlertsManager?
    
    private var barcodeResults: [SBSDKBarcodeItem]?
    private var genericDocumentResult: SBSDKGenericDocumentRecognitionResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importAction = ImportAction(completionHandler: { [weak self] image in
            self?.image = image
        })
        detectorsManager = DetectorsManager(delegate: self)
        alertsManager = AlertsManager(presenter: self)
        updateUI()
    }
    
    @IBAction private func importPhotoButtonPressed(_ sender: Any?) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let fromCameraAction = UIAlertAction(title: "From Camera", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segue.presentScannerCamera.rawValue, sender: self)
        }
        let fromLibraryAction = UIAlertAction(title: "From Photo Library", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.importAction?.showImagePicker(on: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(fromCameraAction)
        alert.addAction(fromLibraryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = importPhotoButton
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func selectDetectorButtonPressed(_ sender: Any?) {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        guard let detectorsManager = detectorsManager else { return }
        for detector in detectorsManager.allDetectors {
            let action = UIAlertAction(title: detector.detectorName, style: .default) { [weak self] _ in
                guard let image = self?.image else { return }
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
    
    func updateUI() {
        imageView.image = image
        selectDetectorButton.isEnabled = image != nil
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
                controller.sourceImage = image
            }
        }
    }
}

extension StaticImageDetectionViewController: ScannerCameraViewControllerDelegate {
    func cameraViewController(_ viewController: ScannerCameraViewController, didCapture image: UIImage) {
        self.image = image
    }
}

extension StaticImageDetectionViewController: DetectorsManagerDelegate {
    
    func scanner(_ scanner: SBSDKBarcodeScanner,
                 didFindBarcodes result: SBSDKBarcodeScannerResult?) {
        guard let result = result, !result.barcodes.isEmpty else {
            alertsManager?.showFailureAlert()
            return
        }
        barcodeResults = result.barcodes
        performSegue(withIdentifier: Segue.showBarcodeResults.rawValue, sender: self)
    }
    
    func recognizer(_ recognizer: SBSDKHealthInsuranceCardRecognizer,
                    didFindEHIC result: SBSDKEuropeanHealthInsuranceCardRecognitionResult?) {
        guard let result = result,
        result.status ==  SBSDKEuropeanHealthInsuranceCardRecognitionResultRecognitionStatus.success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
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
    
    func scanner(_ scanner: SBSDKMRZScanner,
                 didFindMRZ result: SBSDKMRZScannerResult?) {
        guard let result = result, result.success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
    
    func recognizer(_ recognizer: SBSDKMedicalCertificateRecognizer,
                    didFindMedicalCertificate result: SBSDKMedicalCertificateRecognitionResult?) {
        guard let result = result, result.recognitionSuccessful else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
    
    func scanner(_ scanner: SBSDKLicensePlateScanner,
                 didFindLicensePlate result: SBSDKLicensePlateScannerResult?) {
        guard let result = result, !result.rawText.isEmpty else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.rawText)
    }
    
    func recognizer(_ recognizer: SBSDKCheckRecognizer,
                    didFindCheck result: SBSDKCheckRecognitionResult?) {
        guard let result = result,
        result.status == SBSDKCheckRecognitionStatus.success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
    
    func recognizer(_ recognizer: SBSDKCreditCardRecognizer,
                    didFindCreditCard result: SBSDKCreditCardRecognitionResult?) {
        guard let result = result,
        result.recognitionStatus == SBSDKCreditCardRecognitionStatus.success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.stringRepresentation)
    }
    
    func detector(_ detector: SBSDKDocumentDetector, didFindPolygon result: SBSDKDocumentDetectionResult?) {
        guard let result = result, result.isDetectionStatusOK, result.polygon != nil, let image = image else {
            alertsManager?.showFailureAlert()
            return
        }
        let processor = SBSDKImageProcessor(uiImage: image)
        if let polygon = result.polygon {
            processor.applyCrop(polygon: polygon)
        }
        imageView.image = processor.processedImage
    }
}
