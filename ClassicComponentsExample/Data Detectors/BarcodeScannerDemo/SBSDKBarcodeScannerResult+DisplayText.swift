//
//  SBSDKBarcodeScannerResult+DisplayText.swift
//  ClassicComponentsExample
//
//  Created by Sebastian Husche on 06.11.24.
//  Copyright © 2024 doo GmbH. All rights reserved.
//


import ScanbotSDK

import ScanbotSDK

extension SBSDKBarcodeScannerResult {
    var displayText: String {
        if self.rawBytes.count > 0 {
            let rawBytesString = self.rawBytes.map({ String(format: "%02hhx", $0) }).joined()
            return self.rawTextStringWithExtension + "\nRaw bytes: \(rawBytesString)"
        } else {
            return self.rawTextStringWithExtension
        }
    }
}

extension SBSDKUI2BarcodeItem {
    var displayText: String {
        if self.rawBytes.count > 0 {
            let rawBytesString = self.rawBytes.map({ String(format: "%02hhx", $0) }).joined()
            return self.textWithExtension + "\nRaw bytes: \(rawBytesString)"
        } else {
            return self.textWithExtension
        }
    }
}
