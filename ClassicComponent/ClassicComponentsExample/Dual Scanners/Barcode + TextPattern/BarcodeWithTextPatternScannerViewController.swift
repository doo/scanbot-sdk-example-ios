//
//  BarcodeWithTextPatternScannerViewController.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 11.03.26.
//  Copyright © 2026 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

/**
 This view controller demonstrates how to combine Scanbot's Text Pattern Scanner and Barcode Scanner using the additional frame processor feature. 

 With this approach, you can extract EAN codes from either visible text or barcodes within the same scanning UI, providing a seamless user experience for your customers.
*/

enum ScanResult {
    case barcode(String)
    case textPattern(String)
}

// Scans an EAN8 or EAN13 number from either a text line or from a valid barcode.
class BarcodeWithTextPatternScannerViewController: UIViewController {
    
    // The text pattern scanner view controller Classic UI that acts as our main scanner.
    private var textPatternScanner: SBSDKTextPatternScannerViewController?
    
    // The barcode scanner entity we use in additional frame processing to run additional barcode scanning.
    private var barcodeScanner: SBSDKBarcodeScanner?
    
    // The EAN validator to validate the EANs.
    private let validator = EANValidator()
    
    // The final result enum encapsulating the scan value and source.
    var result: ScanResult? {
        didSet {
            if let result { self.handleResult(result) }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the text pattern scanner view controller.
        setupTextPatternScanner()
        
        // Setup the barcode scanner for additional frame processing.
        setupBarcodeScanner()
    }
    
    private func setupTextPatternScanner() {
        
        // Setup the text pattern scanner configuration.
        let textPatternConfiguration = SBSDKTextPatternScannerConfiguration()
        
        // We want to scan single line text patterns only.
        textPatternConfiguration.optimizeSingleLine = true
        
        // Attach the EAN validator to the text pattern scanner configuration.
        let validator = SBSDKCustomContentValidator()
        validator.allowedCharacters = "0123456789"
        
        // Set the custom validator to clean and validate the recognized text as needed.
        validator.callback = EANValidator()
        
        // Set the validator in the configuration object.
        textPatternConfiguration.validator = validator
        
        // Create and embed the text pattern scanner view controller.
        textPatternScanner = SBSDKTextPatternScannerViewController(parentViewController: self,
                                                                   parentView: view,
                                                                   configuration: textPatternConfiguration,
                                                                   delegate: self)
        
        // Configure the view finder of the scanner view controller to be able to scan a text line as well as a 1D barcode.
        textPatternScanner?.viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 5.0, height: 1.0)
        textPatternScanner?.viewFinderConfiguration.isViewFinderEnabled = true
        textPatternScanner?.viewFinderConfiguration.preferredHeight = 50
        
        // Pass self as the additional frame processor.
        // Each video frame is not only passed to the text pattern scanner but also to self, where the barcode scanning is done.
        textPatternScanner?.additionalFrameProcessor = self
    }
    
    private func setupBarcodeScanner() {
        // Setup the barcode scanner that is called in the additional frame processing.
        
        do {
            // Setup the barcode scanner configuration.
            let barcodeConfiguration = SBSDKBarcodeScannerConfiguration()
            
            // The only allowed format is UpcEan without the UPC codes.
            let eanConfiguration = SBSDKBarcodeFormatUpcEanConfiguration()
            eanConfiguration.ean8 = true
            eanConfiguration.ean13 = true
            eanConfiguration.upca = false
            eanConfiguration.upce = false
            
            // We want to keep the check digits for manual validation.
            eanConfiguration.stripCheckDigits = false
            
            // No extensions.
            eanConfiguration.extensions = .ignore
            
            // Pass the format configuration to the barcode scanner configuration.
            barcodeConfiguration.barcodeFormatConfigurations = [
                eanConfiguration
            ]
            
            // And create and store the barcode scanner object.
            barcodeScanner = try SBSDKBarcodeScanner(configuration: barcodeConfiguration)
            
        } catch {
            handleError(error)
        }
    }
}

// The delegate protocol for the embedded text pattern scanner view controller.
extension BarcodeWithTextPatternScannerViewController: SBSDKTextPatternScannerViewControllerDelegate {
    
    func textPatternScannerViewControllerShouldScan(_ controller: SBSDKTextPatternScannerViewController) -> Bool {
        // We want to scan for text patterns as long as we have no result. Delegate calls are made to the main thread.
        return result == nil
    }
    
    func textPatternScannerViewController(_ controller: SBSDKTextPatternScannerViewController,
                                          didScanTextPattern result: SBSDKTextPatternScannerResult) {
        
        if result.validationSuccessful {
            // We found a matching text pattern, so we update the result. Delegate calls are made to the main thread.
            updateResult(textPatternResult: result)
        }
    }
    
    func textPatternScannerViewController(_ controller: ScanbotSDK.SBSDKTextPatternScannerViewController,
                                          didFailScanning error: any Error) {
        showAlert(error: error)
    }
}

// This is the extension that implements additional frame processing. In our case we utilize the barcode scanner here.
extension BarcodeWithTextPatternScannerViewController: SBSDKAdditionalFrameProcessing {
    
    func process(frame: SBSDKImageRef) -> Bool {
        
        // Skip barcode scanning if already have a result.
        guard self.result == nil else { return false }
        
        do {
            let result = try barcodeScanner?.run(image: frame)
            DispatchQueue.main.sync { [weak self] in self?.updateResult(barcodeResult: result) }
        } catch {
            DispatchQueue.main.sync { [weak self] in self?.handleError(error) }
        }
        
        return true
    }
}

// Helping functions.
extension BarcodeWithTextPatternScannerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupInfoButton()
    }
    
    private func reset() {
        result = nil
    }

    private func handleResult(_ result: ScanResult) {
        showAlert(result: result)
    }
    
    private func updateResult(barcodeResult: SBSDKBarcodeScannerResult? = nil,
                              textPatternResult: SBSDKTextPatternScannerResult? = nil) {
        
        if let barcodeResult,
           let string = barcodeResult.barcodes.first?.text,
           validator.isValidEAN(string) {
            result = .barcode(string)
            
        } else if let textPatternResult,
                  validator.isValidEAN(textPatternResult.rawText) {
            result = .textPattern(textPatternResult.rawText)
        }
    }
    
    private func handleError(_ error: Error) {
        showAlert(error: error)
    }
    
    private func showAlert(error: Error? = nil, result: ScanResult? = nil) {
        
        if let error {
            sbsdk_showError(error) { [weak self] _ in
                guard let self else { return }
                self.sbsdk_forceClose(animated: true, completion: nil)
            }
        } else if let result {
            let message: String
            switch result {
            case .barcode(let value):
                message = "Scanned via Barcode: \(value)."
            case .textPattern(let value):
                message = "Scanned via Text Pattern: \(value)."
            }
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.reset() })
            present(alert, animated: true)
        }
    }
    
    private func setupInfoButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showIntroduction))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func showIntroduction() {
        let infoText = "This screen demonstrates how to combine Scanbot SDK's Barcode and Text Pattern Scanners into one seamless user experience using the Additional Frame Processor.\n\nThe Additional Frame Processor lets you apply custom scanning logic to every live camera frame, alongside the main scanner, making your workflows more powerful and flexible.\n\nThis example uses Additional Frame Processor to scan barcodes on top of the main Text Pattern scanner, to scan EAN codes from both barcodes and printed text lines in a single session without switching modes."
        let introVC = IntroductionViewController(title: "Barcode + Text Pattern", infoText: infoText)
        introVC.modalPresentationStyle = .formSheet
        present(introVC, animated: true)
    }
}
