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
            showLicenseAlert()
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
        
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func showDocumentScanning() {
        guardLicense {
            UsecaseScanDocument(document: scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showMultipleObjectsScanning() {
        guardLicense {
            UsecaseScanMultipleObjects(document: scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showTwoDimensionalBarcodeScanning() {
        guardLicense {
            UsecaseScanTwoDimensionalBarcode().start(presenter: self.presenter)
        }
    }
    
    func showTextDataScanner() {
        guardLicense {
            UsecaseScanTextData().start(presenter: self.presenter)
        }
    }
    
    func showCheckRecognizer() {
        guardLicense {
            UsecaseRecognizeCheck().start(presenter: self.presenter)
        }
    }
    
    func showOneDimensionalBarcodeScanning() {
        guardLicense {
            UsecaseScanOneDimensionalBarcode().start(presenter: self.presenter)
        }
    }
    
    func showMRZScanning() {
        guardLicense {
            UsecaseScanMRZ().start(presenter: self.presenter)
        }
    }
    
    func showEHICScanning() {
        guardLicense {
            UsecaseScanEHIC().start(presenter: self.presenter)
        }
    }
    
    func showMedicalCertificateScanning() {
        guardLicense {
            UsecaseScanMedicalCertificate().start(presenter: self.presenter)
        }
    }
    
    func showImportImages() {
        guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showAllImages() {
        guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showBarcodeBatchScanner(additionalParameters: SBSDKBarcodeAdditionalParameters? = nil) {
        guardLicense {
            UsecaseScanBarcodeBatch(additionalParameters: additionalParameters).start(presenter: self.presenter)
        }
    }
    
    func showIDCardScanner() {
        guardLicense {
            UsecaseScanGenericDocument(documentType: .idCardFrontBackDE()).start(presenter: self.presenter)
        }
    }
    
    func showDriverLicenseScanner() {
        guardLicense {
            UsecaseScanGenericDocument(documentType: .driverLicenseFrontBackDE()).start(presenter: self.presenter)
        }
    }
    
    func showLicensePlateScanner() {
        guardLicense {
            UsecaseScanLicensePlate().start(presenter: self.presenter)
        }
    }
}
