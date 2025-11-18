//
//  QualityAnalyzerDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class QualityAnalyzerDemoViewController: UIViewController {
    @IBOutlet private var containerView: UIView!
    private var scannerViewController: SBSDKDocumentScannerViewController?
    private var analyzer: SBSDKDocumentQualityAnalyzer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                   parentView: containerView,
                                                                   delegate: self)
        analyzer = try? SBSDKDocumentQualityAnalyzer()
        scannerViewController?.delegate = self
        scannerViewController?.suppressDetectionStatusLabel = true
        scannerViewController?.suppressPolygonLayer = true
    }
    
    @IBAction private func selectImageButtonDidPress(_ sender: Any) {
        darkenScreen()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    private func estimateAndShowResults(from image: SBSDKImageRef) {
        if let result = try? analyzer?.run(image: image) {
            DispatchQueue.main.async { [weak self] in
                self?.show(result: result)
            }
        }
    }
    
    private func darkenScreen() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.scannerViewController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
        }
    }
    
    private func lightenScreen() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.scannerViewController?.view.backgroundColor = UIColor.clear
            
        }
    }
    
    private func show(result: SBSDKDocumentQualityAnalyzerResult) {
        let quality = result.quality?.stringValue ?? "No document"
        let resultString = "Quality = \(quality)"
        let alert = UIAlertController(title: "Quality Analysis",
                                      message: resultString,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { _ in
            alert.presentedViewController?.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension QualityAnalyzerDemoViewController: SBSDKDocumentScannerViewControllerDelegate {
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: SBSDKImageRef,
                                       on originalImage: SBSDKImageRef,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        estimateAndShowResults(from: originalImage)
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController, didFailScanning error: any Error) {
        handleError(error)
    }
}

extension QualityAnalyzerDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true) { [weak self] in
                let imageRef = SBSDKImageRef.fromUIImage(image: image)
                self?.estimateAndShowResults(from: imageRef)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension SBSDKDocumentQuality {
    var stringValue: String {
        switch self {
        case .veryPoor:
            return "Very Poor"
        case .poor:
            return "Poor"
        case .reasonable:
            return "Reasonable"
        case .good:
            return "Good"
        case .excellent:
            return "Excellent"
        default:
            return ""
        }
    }
}
