//
//  BarcodeFormatter.swift
//  SBBarcodeSDKDemo
//
//  Created by Yevgeniy Knizhnik on 02.12.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class BarcodeFormatter {
    func formattedBarcodeText(_ document: SBSDKGenericDocument?) -> String? {
        guard let document else {
            return nil
        }
        var result = "\n\nDetected type \(document.type.displayText ?? "Unknown")"
        for doc in document.flatDocument(includeEmptyChildren: true, includeEmptyFields: false)! {
            for field in doc.fields {
                if let type = field.type.displayText, let value = field.value?.text {
                    result.append("\n\(type): \(value)")
                }
            }
        }
        return result
    }
}
