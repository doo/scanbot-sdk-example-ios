//
//  MainTableActionHandler.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class MainTableActionHandler: NSObject {
    
    let presenter: UIViewController
    
    private var result = ReviewableScanResult()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func showTextPatternScanner() {
        UsecaseScanTextPattern().start(presenter: self.presenter)
    }
    
    func showCheckScanner() {
        UsecaseScanCheck().start(presenter: self.presenter)
    }
    
    func showMRZScanning() {
        UsecaseScanMRZ().start(presenter: self.presenter)
    }
    
    func showEHICScanning() {
        let documentTypes = [SBSDKDocumentsModelConstants.europeanHealthInsuranceCardDocumentType]
        UsecaseScanDocumentDataExtractor(documentTypes: documentTypes).start(presenter: self.presenter)
    }
    
    func showAllImages() {
        UsecaseBrowseImages(result: result).start(presenter: self.presenter)
    }
    
    func showIDCardScanner() {
        let documentTypes = [SBSDKDocumentsModelConstants.deIdCardBackDocumentType,
                             SBSDKDocumentsModelConstants.deIdCardFrontDocumentType]
        UsecaseScanDocumentDataExtractor(documentTypes: documentTypes)
        .start(presenter: self.presenter)
    }
    
    func showDriverLicenseScanner() {
        let documentTypes = [SBSDKDocumentsModelConstants.europeanDriverLicenseBackDocumentType,
                             SBSDKDocumentsModelConstants.europeanDriverLicenseFrontDocumentType]
        UsecaseScanDocumentDataExtractor(documentTypes: documentTypes)
        .start(presenter: self.presenter)
    }
    
    func showVinScanner() {
        UsecaseScanVIN().start(presenter: self.presenter)
    }
    
    func showCreditCardScanner() {
        UsecaseScanCreditCard().start(presenter: self.presenter)
    }
}
