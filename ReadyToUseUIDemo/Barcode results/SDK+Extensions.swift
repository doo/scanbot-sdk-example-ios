//
//  BarcodeFormat+Type.swift
//  ScanbotBarcodeScannerSDKDemo
//
//  Created by Rana Sohaib on 26.02.24.
//  Copyright © 2024 doo GmbH. All rights reserved.
//

import ScanbotSDK

extension SBSDKUI2BarcodeFormat {
    
    func toBarcodeType() -> SBSDKBarcodeType {
        switch self {
        case .aztec:
            return SBSDKBarcodeType.aztec
        case .codabar:
            return SBSDKBarcodeType.codaBar
        case .code25:
            return SBSDKBarcodeType.code25
        case .code39:
            return SBSDKBarcodeType.code39
        case .code93:
            return SBSDKBarcodeType.code93
        case .code128:
            return SBSDKBarcodeType.code128
        case .dataMatrix:
            return SBSDKBarcodeType.dataMatrix
        case .ean8:
            return SBSDKBarcodeType.ean8
        case .ean13:
            return SBSDKBarcodeType.ean13
        case .itf:
            return SBSDKBarcodeType.itf
        case .pdf417:
            return SBSDKBarcodeType.pdf417
        case .qrCode:
            return SBSDKBarcodeType.qrCode
        case .microQrCode:
            return SBSDKBarcodeType.microQrCode
        case .databar:
            return SBSDKBarcodeType.databar
        case .databarLimited:
            return SBSDKBarcodeType.databarLimited
        case .upcA:
            return SBSDKBarcodeType.upcA
        case .upcE:
            return SBSDKBarcodeType.upcE
        case .msiPlessey:
            return SBSDKBarcodeType.msiPlessey
        case .iata2Of5:
            return SBSDKBarcodeType.iata2Of5
        case .industrial2Of5:
            return SBSDKBarcodeType.industrial2Of5
        case .uspsIntelligentMail:
            return SBSDKBarcodeType.uspsIntelligentMail
        case .royalMail:
            return SBSDKBarcodeType.royalMail
        case .japanPost:
            return SBSDKBarcodeType.japanPost
        case .royalTntPost:
            return SBSDKBarcodeType.royalTNTPpost
        case .australiaPost:
            return SBSDKBarcodeType.australiaPost
        case .gs1Composite:
            return SBSDKBarcodeType.gs1Composite
        case .databarExpanded:
            return SBSDKBarcodeType.databarExpanded
        case .microPdf417:
            return .microPdf417
        default: fatalError("Unknown barcode format")
        }
    }
}
