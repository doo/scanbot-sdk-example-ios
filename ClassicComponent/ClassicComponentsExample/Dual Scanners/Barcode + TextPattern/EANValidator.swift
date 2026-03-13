//
//  EANValidator.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 13.03.26.
//  Copyright © 2026 doo GmbH. All rights reserved.
//

import ScanbotSDK

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
