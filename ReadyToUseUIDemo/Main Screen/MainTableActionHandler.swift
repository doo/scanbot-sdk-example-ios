//
//  MainTableActionHandler.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class MainTableActionHandler: NSObject {
    
    let presenter: UIViewController
    
    private(set) var scannedDocument = SBSDKUIDocument()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func showDocumentScanning() {
        UsecaseScanDocument(document: self.scannedDocument).start(presenter: self.presenter)
    }
    
    func showQRCodeScanning() {
        UsecaseScanQRCode().start(presenter: self.presenter)
    }
    
    func showBarcodeScanning() {
        UsecaseScanBarcode().start(presenter: self.presenter)
    }
    
    func showMRZScanning() {
        UsecaseScanMRZ().start(presenter: self.presenter)
    }
    
    func showImportImages() {
        UsecaseImportImage(document: self.scannedDocument).start(presenter: self.presenter)
    }
    
    func showAllImages() {
        UsecaseBrowseDocumentPages(document: self.scannedDocument).start(presenter: self.presenter)
    }
}
