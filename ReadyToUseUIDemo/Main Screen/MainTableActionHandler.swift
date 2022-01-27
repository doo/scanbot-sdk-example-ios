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

    private func guardLicense(_ block: () -> ()) {
        if ScanbotSDK.isLicenseValid() {
            block()
        } else {
            self.showLicenseAlert()
        }
    }
    
    private func showLicenseAlert() {
        let alert = UIAlertController(title: "Demo expired",
                                      message: "The demo app will terminate because of the missing license key. Get your free 30-day license today!",
                                      preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close App", style: .default) { (_) in
            self.presenter.dismiss(animated: true)
        }
        
        let getLicenseAction = UIAlertAction(title: "Get License", style: .cancel) { (_) in
            let url = URL(string: "https://scanbot.io/sdk/")!
            UIApplication.shared.open(url, options: [:]) { _ in
                objc_terminate()
            }
        }
        
        alert.addAction(closeAction)
        alert.addAction(getLicenseAction)
        alert.actions.forEach { (action) in
            action.setValue(UIColor.black, forKey: "titleTextColor")
        }
        
        self.presenter.present(alert, animated: true, completion: nil)
    }
    
    func showDocumentScanning() {
        self.guardLicense {
            UsecaseScanDocument(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showMultipleObjectsScanning() {
        self.guardLicense {
            UsecaseScanMultipleObjects(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showTwoDimensionalBarcodeScanning() {
        self.guardLicense {
            UsecaseScanTwoDimensionalBarcode().start(presenter: self.presenter)
        }
    }
    
    func showTextDataScanner() {
        self.guardLicense {
            UsecaseScanTextData().start(presenter: self.presenter)
        }
    }
    
    func showOneDimensionalBarcodeScanning() {
        self.guardLicense {
            UsecaseScanOneDimensionalBarcode().start(presenter: self.presenter)
        }
    }
    
    func showMRZScanning() {
        self.guardLicense {
            UsecaseScanMRZ().start(presenter: self.presenter)
        }
    }
    
    func showEHICScanning() {
        self.guardLicense {
            UsecaseScanEHIC().start(presenter: self.presenter)
        }
    }
    
    func showImportImages() {
        self.guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showAllImages() {
        self.guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showWorkflow() {
        self.guardLicense {
            UsecaseStartWorkflow().start(presenter: self.presenter)
        }
    }
    
    func showBarcodeBatchScanner(engineMode: SBSDKBarcodeEngineMode,
                                 additionalParameters: SBSDKBarcodeAdditionalParameters? = nil) {
        self.guardLicense {
            UsecaseScanBarcodeBatch(engineMode: engineMode,
                                    additionalParameters: additionalParameters).start(presenter: self.presenter)
        }
    }
    
    func showIDCardScanner() {
        self.guardLicense {
            UsecaseGenericDocumentScan(documentType: .idCardFrontBackDE()).start(presenter: self.presenter)
        }
    }

    func showDriverLicenseScanner() {
        self.guardLicense {
            UsecaseGenericDocumentScan(documentType: .driverLicenseFrontBackDE()).start(presenter: self.presenter)
        }
    }

    func showLicensePlateScanner() {
        self.guardLicense {
            UsecaseScanLicensePlate().start(presenter: self.presenter)
        }
    }
}
