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
    
    private var image: SBSDKImageRef? {
        didSet {
            updateUI()
        }
    }
    
    private var importAction: ImportAction?
    private var detectorsManager: DetectorsManager?
    private var alertsManager: AlertsManager?
    
    private var barcodeResults: [SBSDKBarcodeItem]?
    private var documentDataExtractorResult: SBSDKDocumentDataExtractionResult?
    
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
                do {
                    try detectorsManager.detectInfo(on: image, using: detector)
                } catch {
                    self?.handleError(error)
                }
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
        imageView.image = try? image?.toUIImage()
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
            if let controller = segue.destination as? DocumentDataExtractorResultViewController {
                controller.document = documentDataExtractorResult?.document
                controller.sourceImage = image
            }
        }
    }
}

extension StaticImageDetectionViewController: ScannerCameraViewControllerDelegate {
    func cameraViewController(_ viewController: ScannerCameraViewController, didCapture image: SBSDKImageRef) {
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
    
    func extractor(_ extractor: SBSDKDocumentDataExtractor,
                   didExtractDocument result: SBSDKDocumentDataExtractionResult?) {
        guard let result = result else {
            alertsManager?.showFailureAlert()
            return
        }
        documentDataExtractorResult = result
        performSegue(withIdentifier: Segue.showGenericDocumentResult.rawValue, sender: self)
    }
    
    func scanner(_ scanner: SBSDKMRZScanner,
                 didScanMRZ result: SBSDKMRZScannerResult?) {
        guard let result = result else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
    
    func scanner(_ scanner: SBSDKMedicalCertificateScanner,
                 didScanMedicalCertificate result: SBSDKMedicalCertificateScanningResult?) {
        guard let result = result, result.scanningSuccessful else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
        
    func scanner(_ recognizer: SBSDKCheckScanner,
                 didScanCheck result: SBSDKCheckScanningResult?) {
        guard let result = result,
              result.status == .success else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.toJson())
    }
    
    func scanner(_ recognizer: SBSDKCreditCardScanner,
                 didScanCreditCard result: SBSDKCreditCardScanningResult?) {
        guard let result = result, result.creditCard != nil else {
            alertsManager?.showFailureAlert()
            return
        }
        alertsManager?.showSuccessAlert(with: result.stringRepresentation)
    }
    
    func scanner(_ scanner: SBSDKDocumentScanner, didFindPolygon result: SBSDKDocumentDetectionResult?) {
        guard let result = result, result.isScanningStatusOK, result.polygon != nil, let image = image else {
            alertsManager?.showFailureAlert()
            return
        }
        let processor = SBSDKImageProcessor()
        if let polygon = result.polygon {
            do {
                imageView.image = try processor.crop(image: image, polygon: polygon).toUIImage()
            } catch {
                print("Error cropping image: \(error.localizedDescription)")
            }
        }
    }
}
