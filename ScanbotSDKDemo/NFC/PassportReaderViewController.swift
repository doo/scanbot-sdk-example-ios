//
//  PassportReaderViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 18.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

@available(iOS 13.0, *)
class PassportReaderViewController: UIViewController {
    
    private var nfcReader: SBSDKNFCPassportReader?
    private var passportNumber: String?
    private var birthDate: Date?
    private var expirationDate: Date?
    private var mrzController: SBSDKUIMRZScannerViewController?
    private var currentResults: [SBSDKNFCDatagroup]?
    
    @IBOutlet private var progressView: UIProgressView?
    
    private func commonInit() {
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = SBSDKUIMRZScannerConfiguration.default()
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 1.0, andHeight: 0.18)
        configuration.uiConfiguration.isCancelButtonHidden = true
        configuration.textConfiguration.finderTextHint =
        "Please align the passports machine readable zone with the frame above to scan it."
        
        mrzController = SBSDKUIMRZScannerViewController.createNew(with: configuration, andDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mrzController?.isRecognitionEnabled = true
        guard let mrzController = mrzController, let progressView = progressView else { return }

        sbsdk_attach(mrzController, in: view)
        view.bringSubviewToFront(progressView)
    }
    
    private func startNFCScanning() {
        mrzController?.isRecognitionEnabled = false
        guard let passportNumber = passportNumber,
              let birthDate = birthDate,
              let expirationDate = expirationDate else { return }

        nfcReader = SBSDKNFCPassportReader(passportNumber: passportNumber,
                                        birthDate: birthDate,
                                        expirationDate: expirationDate,
                                        initialMessage: "Hold your phone over the passport.",
                                        delegate: self)
        nfcReader?.setMessage("Authenticating with passport...")
    }
    
    private func showResultsIfNeeded() {
        guard let currentResults = currentResults, !currentResults.isEmpty else {
            mrzController?.isRecognitionEnabled = true
            return
        }
        let controller = PassportReaderResultsViewController.make(with: currentResults)
        navigationController?.pushViewController(controller, animated: true)
        self.currentResults = nil
    }
}

@available(iOS 13.0, *)
extension PassportReaderViewController: SBSDKUIMRZScannerViewControllerDelegate {
    func mrzDetectionViewController(_ viewController: SBSDKUIMRZScannerViewController,
                                    didDetect zone: SBSDKMachineReadableZoneRecognizerResult) {
        if mrzController?.isRecognitionEnabled == false {
            return
        }
        if zone.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentType.passport ||
            !zone.recognitionSuccessful {
            return
        }
        passportNumber = zone.documentCodeField?.value
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd.MM.yy"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        birthDate = dateFormatter.date(from: zone.dateOfBirthField!.value)
        expirationDate = dateFormatter.date(from: zone.dateOfExpiryField!.value)
        startNFCScanning()
    }
}

@available(iOS 13.0, *)
extension PassportReaderViewController: SBSDKPassportReaderDelegate {
    
    func passportReaderDidConnect(_ reader: SBSDKNFCPassportReader) {
        nfcReader?.setMessage("Enumerating available data groups...")
        reader.enumerateDatagroups { [weak self] types in
            self?.nfcReader?.setMessage("Downloading data groups...")
            reader.downloadDatagroups(ofType: types) { groups in
                self?.nfcReader?.setMessage("Finished downloading data groups.")
                if !groups.isEmpty {
                    self?.currentResults = groups
                    DispatchQueue.main.async { [weak self] in
                        self?.showResultsIfNeeded()
                    }
                }
            }
        }
    }
    
    func passportReader(_ reader: SBSDKNFCPassportReader, didStartReadingGroup type: String) {
        nfcReader?.setMessage("Downloading data group \(type)...")
        progressView?.progress = 0.0
        progressView?.isHidden = false
    }
    
    func passportReader(_ reader: SBSDKNFCPassportReader, didProgressReadingGroup progress: Float) {
        progressView?.progress = progress
        progressView?.isHidden = false
    }
    
    func passportReader(_ reader: SBSDKNFCPassportReader, didFinishReadingGroup type: String) {
        nfcReader?.setMessage("Finished downloading data group \(type)...")
        progressView?.progress = 1.0
        progressView?.isHidden = true
    }
    
    func passportReaderDidFinishSession(_ reader: SBSDKNFCPassportReader) {
        progressView?.isHidden = true
        mrzController?.isRecognitionEnabled = true
    }
    
    func passportReaderDidCancelSession(_ reader: SBSDKNFCPassportReader) {
        progressView?.isHidden = true
        mrzController?.isRecognitionEnabled = true
    }
}
