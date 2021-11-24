//
//  ChequeViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK


class ChequeViewController: UIViewController {
    private lazy var cameraSession: SBSDKCameraSession = {
       let cameraSession = SBSDKCameraSession(for: FeatureCheque)
        cameraSession.videoDelegate = self
        return cameraSession
    }()
    private let recognizer = SBSDKChequeRecognizer()
    private let polygonLayer = SBSDKPolygonLayer(lineColor: UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0))
    private var recognitionEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(cameraSession.previewLayer)
        view.layer.addSublayer(polygonLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraSession.start()
        recognitionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraSession.previewLayer.frame = view.bounds
        polygonLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        cameraSession.videoOrientation = videoOrientationFromInterfaceOrientation()
    }
    
    private func show(result: SBSDKChequeRecognizerResult) {
        polygonLayer.path = result.polygon?.bezierPath(for: cameraSession.previewLayer).cgPath
        guard result.routingNumberField?.value?.isEmpty != true else { return }
        
        polygonLayer.path = nil
        recognitionEnabled = false
        
        var messageString = ""
        if let value = result.routingNumberField?.value, !value.isEmpty {
            messageString += "Routing number: \(value)"
        }
        if let value = result.accountNumberField?.value, !value.isEmpty {
            messageString += "Account number: \(value)"
        }
        if let value = result.chequeNumberField?.value, !value.isEmpty {
            messageString += "Cheque number: \(value)"
        }
        let alert = UIAlertController(title: "Recognized Cheque",
                                      message: messageString,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: { [weak self] _ in
           self?.recognitionEnabled = true
       })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ChequeViewController: SBSDKCameraSessionDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard recognitionEnabled else { return }
        
        let orientation = cameraSession.videoOrientation
        if let result = recognizer.recognizeCheque(on: sampleBuffer, orientation: orientation) {
            DispatchQueue.main.async { [weak self] in
                self?.show(result: result)
            }
        }
    }
}
