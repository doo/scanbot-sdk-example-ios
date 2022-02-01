//
//  EHICDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class EHICDemoViewController: UIViewController {
    @IBOutlet private var statusLabel: UILabel?
    private let recognizer = SBSDKHealthInsuranceCardRecognizer()
    private lazy var cameraSession: SBSDKCameraSession = {
       let cameraSession = SBSDKCameraSession(for: FeatureEHICRecognition)
        cameraSession.videoDelegate = self
        return cameraSession
    }()
    private var isRecognitionEnabled: Bool = true
    private var machineReadableZoneRect: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(cameraSession.previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraSession.start()
        guard let statusView = statusLabel else { return }
        view.bringSubviewToFront(statusView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraSession.previewLayer.frame = view.bounds
        updateVideoOrientation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateVideoOrientation()
    }
    
    private func show(result: SBSDKHealthInsuranceCardRecognitionResult) {
        switch result.status {
        case .success:
            statusLabel?.text = "Card recognized"
        case .failedDetection:
            statusLabel?.text = "Please align the back side of the card in the frame to scan it"
        case .incompleteValidation:
            statusLabel?.text = "Card found, please wait..."
        default:
            break
        }
        isRecognitionEnabled = false
        let resultMessage = result.stringRepresentation()
        let alert = UIAlertController(title: "Result",
                                      message: resultMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { [weak self] _ in
            self?.isRecognitionEnabled = true
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
        
    private func updateVideoOrientation() {
        cameraSession.videoOrientation = videoOrientationFromInterfaceOrientation()
    }
}

extension EHICDemoViewController: SBSDKCameraSessionDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        if isRecognitionEnabled {
            if let result = recognizer.recognize(from: sampleBuffer,
                                                 orientation: cameraSession.videoOrientation),
               result.status == SBSDKHealthInsuranceCardDetectionStatus.success {
                DispatchQueue.main.async { [weak self] in
                    self?.show(result: result)
                }
            }
        }
    }
}

extension EHICDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isRecognitionEnabled = true
        if !cameraSession.isSessionRunning() {
            cameraSession.start()
        }
    }
}
