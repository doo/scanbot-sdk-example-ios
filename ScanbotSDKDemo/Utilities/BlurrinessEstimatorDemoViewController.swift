//
//  BlurrinessEstimatorDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BlurrinessEstimatorDemoViewController: UIViewController {
    @IBOutlet private var containerView: UIView?
    private var scannerViewController: SBSDKScannerViewController?
    private var estimator: SBSDKBlurrinessEstimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKScannerViewController(parentViewController: self,
                                                           parentView: containerView,
                                                           imageStorage: nil,
                                                           enableQRCodeDetection: false)
        estimator = SBSDKBlurrinessEstimator()
        scannerViewController?.delegate = self
        scannerViewController?.detectionStatusHidden = true
    }
    
    @IBAction private func selectImageButtonDidPress(_ sender: Any) {
        darkenScreen()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
    private func estimateAndShowResults(from image: UIImage) {
        if let result = estimator?.estimateImageBlurriness(image) {
            DispatchQueue.main.async { [weak self] in
                self?.show(result: result)
            }
        }
    }
    
    private func darkenScreen() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.scannerViewController?.hudView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
    }
    
    private func lightenScreen() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.scannerViewController?.hudView.backgroundColor = UIColor.clear
        }
    }
    
    private func show(result: Double) {
        let resultString = "Bluriness = \(result * 100)"
        let alert = UIAlertController(title: "Bluriness Estimation",
                                      message: resultString,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { [weak self] action in
            self?.lightenScreen()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension BlurrinessEstimatorDemoViewController: SBSDKScannerViewControllerDelegate {
    func scannerControllerShouldAnalyseVideoFrame(_ controller: SBSDKScannerViewController) -> Bool {
        return false
    }
    
    func scannerControllerWillCaptureStillImage(_ controller: SBSDKScannerViewController) {
        darkenScreen()
    }
    
    func scannerController(_ controller: SBSDKScannerViewController, didCapture image: UIImage) {
        estimateAndShowResults(from: image)
    }
    
    func scannerController(_ controller: SBSDKScannerViewController, didFailCapturingImage error: Error) {
        lightenScreen()
    }
}

extension BlurrinessEstimatorDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            dismiss(animated: true) { [weak self] in
                self?.estimateAndShowResults(from: image)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) { [weak self] in
            self?.lightenScreen()
        }
    }
}
