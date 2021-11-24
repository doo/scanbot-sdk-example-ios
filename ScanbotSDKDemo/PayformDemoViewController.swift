//
//  PayformDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class PayformDemoViewController: UIViewController {
    private lazy var cameraSession: SBSDKCameraSession = {
       let cameraSession = SBSDKCameraSession(for: FeaturePayformDetection)
        cameraSession.videoDelegate = self
        return cameraSession
    }()
    private let payformScanner = SBSDKPayFormScanner()
    private var isDetectionEnabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.layer.addSublayer(cameraSession.previewLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraSession.start()
        isDetectionEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isDetectionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraSession.previewLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        cameraSession.videoOrientation = videoOrientationFromInterfaceOrientation()
    }
    
    private func string(from field: SBSDKPayFormRecognizedField) -> String {
        var tokenName = "Unknown token"
        switch field.token.type {
        case .receiver:
            tokenName = "Receiver"
        case .IBAN:
            tokenName = "IBAN"
        case .BIC:
            tokenName = "BIC"
        case .bankName:
            tokenName = "Bank name"
        case .amount:
            tokenName = "Amount"
        case .referenceNumber:
            tokenName = "Reference number"
        case .referenceNumber2:
            tokenName = "Reference number 2"
        case .sender:
            tokenName = "Sender"
        case .senderIBAN:
            tokenName = "Sender IBAN"
        default:
            break
        }
        let value = field.value ?? ""
        return tokenName + ": \(value.isEmpty ? "-" : value)"
    }
    
    private func string(from result: SBSDKPayFormRecognitionResult) -> String {
        var fields: [String] = []
        for field in result.recognizedFields {
            let fieldString = string(from: field)
            fields.append(fieldString)
        }
        return fields.joined(separator: "\n")
    }
    
    private func present(result: SBSDKPayFormRecognitionResult) {
        let alert = UIAlertController(title: "PayformDetected",
                                      message: string(from: result),
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { [weak self] _ in
            self?.isDetectionEnabled = true
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension PayformDemoViewController: SBSDKCameraSessionDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard isDetectionEnabled else { return }
        
        let orientation = cameraSession.videoOrientation
        if let recognitionResult = payformScanner.recognize(from: sampleBuffer, orientation: orientation),
           recognitionResult.recognitionSuccessful {
            DispatchQueue.main.async { [weak self] in
                self?.present(result: recognitionResult)
            }
        }
    }
}
