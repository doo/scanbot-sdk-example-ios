//
//  AdditionalFrameProcessorViewController.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 11.03.26.
//  Copyright © 2026 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

// Scans an EAN8 or EAN13 number from either a text line or from a valid barcode.
class AdditionalFrameProcessorViewController: UIViewController {
    
    // The text pattern scanner view controller Classic UI that acts as our main scanner
    private var textPatternScanner: SBSDKTextPatternScannerViewController!
    
    // The barcode scanner entity we use in additional frame processing to run additional barcode scanning.
    private var barcodeScanner: SBSDKBarcodeScanner!
    
    // The EAN validator to validate the EANs.
    private let validator = EANValidator()
    
    // The final result string.
    var result: String? {
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
        validator.callback = EANValidator()
        textPatternConfiguration.validator = validator
        
        // Create and embed the text pattern scanner view controller.
        textPatternScanner = SBSDKTextPatternScannerViewController(parentViewController: self,
                                                                   parentView: view,
                                                                   configuration: textPatternConfiguration,
                                                                   delegate: self)
        
        // Configure the view finder of the scanner view controller to be able to scan a text line as well as a 1D barcode.
        textPatternScanner.viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 5.0, height: 1.0)
        textPatternScanner.viewFinderConfiguration.isViewFinderEnabled = true
        textPatternScanner.viewFinderConfiguration.preferredHeight = 50
        
        // Pass self as the additional frame processor.
        // Each video frame is not only passed to the text pattern scanner but also to self, where the barcode scanning is done.
        textPatternScanner.additionalFrameProcessor = self
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

    private func reset() {
        // Reset the scanned result and continues scanning.
        result = nil
    }

    private func handleResult(_ result: String) {
        // Handle the final scanned EAN code here.
        showAlert(result: result)
    }
    
    private func updateResult(barcodeResult: SBSDKBarcodeScannerResult? = nil,
                              textPatternResult: SBSDKTextPatternScannerResult? = nil) {
        
        // Extract the EAN string from the barcode results
        if let barcodeResult, let string = barcodeResult.barcodes.first?.text, validator.isValidEAN(string) {
            result = string
        // ... or from the text pattern scanner result
        } else if let textPatternResult, validator.isValidEAN(textPatternResult.rawText) {
            result = textPatternResult.rawText
        }
    }
    
    private func handleError(_ error: Error) {
        // Handle any error here
        showAlert(error: error)
    }
    
    private func showAlert(error: Error? = nil, result: String? = nil) {
        // Helper function to either alert an error or a valid result.
        if let error {
            // Handle an error.
            let message = "An error occurred: \(error.localizedDescription)."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.reset()
            }))
            present(alert, animated: true)
            
        } else if let result {
            // Handle a valid EAN result.
            let message = "Scanned EAN: \(result)."
            let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.reset()
            }))
            present(alert, animated: true)
        }
    }
}

// The delegate protocol for the embedded text pattern scanner view controller.
extension AdditionalFrameProcessorViewController: SBSDKTextPatternScannerViewControllerDelegate {
    
    func textPatternScannerViewControllerShouldScan(_ controller: SBSDKTextPatternScannerViewController) -> Bool {
        // We want to scan for text patterns as long as we have no result. Delegate calls are made to the main thread.
        return result == nil
    }
    
    func textPatternScannerViewController(_ controller: SBSDKTextPatternScannerViewController,
                                          didScanTextPattern result: SBSDKTextPatternScannerResult) {
        
        if result.validationSuccessful {
            // We found a matching text pattern, so we update the result. Delegate calls are made to the main thread.
            self.updateResult(textPatternResult: result)
        }
    }
    
    func textPatternScannerViewController(_ controller: ScanbotSDK.SBSDKTextPatternScannerViewController,
                                          didFailScanning error: any Error) {
    }
}

// This is the extension that implements additional frame processing. In our case we utilize the barcode scanner here.
extension AdditionalFrameProcessorViewController: SBSDKAdditionalFrameProcessing {
    
    func process(frame: SBSDKImageRef) -> Bool {
        
        // No need to scan if we already have a result. Skip over barcode scanning.
        guard self.result == nil else { return false }
        
        do {
            // Run the barcode scanner on the video frame and pass the result to the update function
            let result = try barcodeScanner.run(image: frame)
            
            // Dispatch the result to the main thread.
            DispatchQueue.main.sync { [weak self] in self?.updateResult(barcodeResult: result) }
        } catch {
            // ... or the error.
            DispatchQueue.main.sync { [weak self] in self?.handleError(error) }
        }
        return true
    }
}

class EANValidator: NSObject, SBSDKContentValidationCallback {
    
    // SBSDKContentValidationCallback protocol implementation to validate text.
    func validate(text: String) -> Bool {
        return isValidEAN(text)
    }
    
    // SBSDKContentValidationCallback protocol implementation to clean up text.
    func clean(rawText: String) -> String {
        return rawText.replacingOccurrences(of: " ", with: "")
    }
    
    // The actual EAN8 or EAN13 validation function.
    func isValidEAN(_ code: String) -> Bool {
        // 1. Validate length and numeric characters
        guard (code.count == 8 || code.count == 13),
              code.allSatisfy(\.isNumber),
              let lastChar = code.last,
              let providedChecksum = lastChar.wholeNumberValue else {
            return false
        }
        
        // 2. Drop the checksum, reverse, and calculate
        let payload = code.dropLast().reversed()
        var sum = 0
        
        for (index, char) in payload.enumerated() {
            guard let digit = char.wholeNumberValue else { return false }
            // Even indices (0, 2, 4...) get multiplied by 3
            let multiplier = (index % 2 == 0) ? 3 : 1
            sum += digit * multiplier
        }
        
        // 3. Modulo 10 calculation
        let calculatedChecksum = (10 - (sum % 10)) % 10
        
        return calculatedChecksum == providedChecksum
    }
}
