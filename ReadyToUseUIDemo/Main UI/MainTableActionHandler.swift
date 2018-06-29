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
        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        SBSDKUIDocumentScannerViewController.present(on: self.presenter,
                                                     with: self.scannedDocument,
                                                     with: configuration,
                                                     andDelegate: self)
    }
    
    func showQRCodeScanning() {
        let configuration = SBSDKUIMachineCodeScannerConfiguration.default()
        let codeTypes = SBSDKUIMachineCodesCollection.twoDimensionalBarcodes()

        SBSDKUIBarcodeScannerViewController.present(on: self.presenter,
                                                    withAcceptedMachineCodeTypes: codeTypes,
                                                    configuration: configuration,
                                                    andDelegate: self)
    }
    
    func showBarcodeScanning() {
        let configuration = SBSDKUIMachineCodeScannerConfiguration.default()
        let codeTypes = SBSDKUIMachineCodesCollection.oneDimensionalBarcodes()

        SBSDKUIBarcodeScannerViewController.present(on: self.presenter,
                                                    withAcceptedMachineCodeTypes: codeTypes,
                                                    configuration: configuration,
                                                    andDelegate: self)
    }
    
    func showMRZScanning() {
        let configuration = SBSDKUIMachineCodeScannerConfiguration.default()
        let viewSize = self.presenter.view.frame.size
        let targetWidth = viewSize.width - ((viewSize.width * 0.058) * 2)
        configuration.uiConfiguration.finderWidth = targetWidth
        configuration.uiConfiguration.finderHeight = targetWidth * 0.3

        SBSDKUIMRZScannerViewController.present(on: self.presenter, with: configuration, andDelegate: self)
    }
    
    func showCropping() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.presenter.present(picker, animated: true, completion: nil)
    }
    
    func showCroppingForPage(_ page: SBSDKUIPage) {
        let configuration = SBSDKUICroppingScreenConfiguration.default()
        configuration.uiConfiguration.backgroundColor = UIColor.darkGray
        SBSDKUICroppingViewController.present(on: self.presenter,
                                              with: page,
                                              with: configuration,
                                              andDelegate: self)
    }
    
    func showAllImages() {
        let browser = ImageBrowserViewController.createNewWithDocument(self.scannedDocument, andDelegate: self)
        self.presenter.navigationController?.pushViewController(browser, animated: true)
    }
    
    func deleteAllImages() {
        SBSDKUIPageFileStorage.default().removeAll()
        self.scannedDocument = SBSDKUIDocument()
    }
}

extension MainTableActionHandler: SBSDKUIDocumentScannerViewControllerDelegate {
    
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        self.showAllImages()
    }
}

extension MainTableActionHandler: SBSDKUIBarcodeScannerViewControllerDelegate {

    func qrBarcodeDetectionViewController(_ viewController: SBSDKUIBarcodeScannerViewController,
                                          didDetect code: SBSDKMachineReadableCode) {
        
        guard let message = code.stringValue else { return }
        let title = code.isQRCode() ? "QR code detected" : "Barcode detected"
        
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }
}

extension MainTableActionHandler: SBSDKUIMRZScannerViewControllerDelegate {
    
    func mrzDetectionViewController(_ viewController: SBSDKUIMRZScannerViewController,
                                    didDetect zone: SBSDKMachineReadableZoneRecognizerResult) {
        
        let title = "MRZ detected"
        let message = zone.stringRepresentation()
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }
}

extension MainTableActionHandler: SBSDKUICroppingViewControllerDelegate {
    
    func croppingViewController(_ viewController: SBSDKUICroppingViewController, didFinish changedPage: SBSDKUIPage) {
        if self.scannedDocument.page(withPageFileID: changedPage.pageFileUUID) == nil {
            self.scannedDocument.add(changedPage)
        }
    }
}

extension MainTableActionHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.presentingViewController?.dismiss(animated: true, completion: {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                return
            }
            guard let uuid = SBSDKUIPageFileStorage.default().add(image.sbsdk_imageWithFixedOrientation()!) else {
                return
            }
            let page = SBSDKUIPage(pageFileID: uuid, polygon: nil)
            self.showCroppingForPage(page)
        })
    }
}

extension MainTableActionHandler: ImageBrowserViewControllerDelegate {
    
    func imageBrowser(_ imageBrowser: ImageBrowserViewController, didSelectPage page: SBSDKUIPage) {
        self.showCroppingForPage(page)
    }
}
