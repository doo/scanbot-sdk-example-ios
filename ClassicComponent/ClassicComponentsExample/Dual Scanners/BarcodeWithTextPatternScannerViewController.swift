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

enum ScanSource {
    case barcode
    case textPattern
}

// Scans an EAN8 or EAN13 number from either a text line or from a valid barcode.
class BarcodeWithTextPatternScannerViewController: UIViewController {
    
    // The text pattern scanner view controller Classic UI that acts as our main scanner.
    private var textPatternScanner: SBSDKTextPatternScannerViewController?
    
    // The barcode scanner entity we use in additional frame processing to run additional barcode scanning.
    private var barcodeScanner: SBSDKBarcodeScanner?
    
    // The EAN validator to validate the EANs.
    private let validator = EANValidator()
    
    // The final result string and its source.
    var result: (value: String, source: ScanSource)? {
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
        
        // Info button.
        setupInfoButton()
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

/**
 EANValidator is a custom content validator for EAN-8 and EAN-13 codes.

 Implements the SBSDKContentValidationCallback protocol, providing validation and cleanup of scanned text for use in barcode and text pattern recognition workflows.
 Ensures only valid, properly checksummed EAN codes are accepted.
*/
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

// Result handling: shows scan source to user.
extension BarcodeWithTextPatternScannerViewController {
    
    private func reset() {
        result = nil
    }

    private func handleResult(_ result: (value: String, source: ScanSource)) {
        showAlert(result: result)
    }
    
    private func updateResult(barcodeResult: SBSDKBarcodeScannerResult? = nil,
                              textPatternResult: SBSDKTextPatternScannerResult? = nil) {
        
        if let barcodeResult,
           let string = barcodeResult.barcodes.first?.text,
           validator.isValidEAN(string) {
            result = (string, .barcode)
            
        } else if let textPatternResult,
                  validator.isValidEAN(textPatternResult.rawText) {
            result = (textPatternResult.rawText, .textPattern)
        }
    }
    
    private func handleError(_ error: Error) {
        showAlert(error: error)
    }
    
    private func showAlert(error: Error? = nil, result: (value: String, source: ScanSource)? = nil) {
        
        if let error {
            let message = "An error occurred: \(error.localizedDescription)."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.reset() })
            present(alert, animated: true)
            
        } else if let result {
            let sourceDescription = result.source == .barcode ? "Barcode" : "Text Pattern"
            let message = "Scanned via \(sourceDescription): \(result.value)."
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
