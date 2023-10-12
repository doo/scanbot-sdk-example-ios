//
//  UsecaseScanDocumentWithPDF.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 12.10.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanDocumentWithPDF: Usecase, SBSDKUIDocumentScannerViewControllerDelegate, UINavigationControllerDelegate {
    
    private let document: SBSDKUIDocument
    private static var currentSettings: SBSDKUIDocumentScannerSettings?
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        // Customize text resources, behavior and UI:
        configuration.behaviorConfiguration.ignoreBadAspectRatio = true
        //configuration.textConfiguration.cancelButtonTitle = "Abort"
        //configuration.textConfiguration.pageCounterButtonTitle = "%d Pages"
        //configuration.behaviorConfiguration.isAutoSnappingEnabled = false
        //configuration.uiConfiguration.bottomBarBackgroundColor = UIColor.blue
        // see further configs ...
        
        // Restore last settings
        if let currentSettings = Self.currentSettings {
            configuration.behaviorConfiguration.isFlashEnabled = currentSettings.flashEnabled
            configuration.behaviorConfiguration.isAutoSnappingEnabled = currentSettings.autoSnappingEnabled
            configuration.behaviorConfiguration.isMultiPageEnabled = currentSettings.multiPageEnabled
        }
        
        let scanner = SBSDKUIDocumentScannerViewController.createNew(with: self.document,
                                                                     configuration: configuration,
                                                                     andDelegate: self)
        
        presentViewController(scanner)
    }
        
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
        
        Self.currentSettings = viewController.currentSettings
        if document.numberOfPages() > 0 {
            createAndSharePDF(document) { 
                self.didFinish()    
            }
        }
    }
    
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        Self.currentSettings = viewController.currentSettings
        didFinish()
    }
    
    func createAndSharePDF(_ document: SBSDKUIDocument, completion: @escaping() -> ()) {
        let pdfURL = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent("Document.pdf")
        
        let pageSize: SBSDKPDFRendererPageSize = .A4
        let pageOrientation: SBSDKPDFRendererPageOrientation = .auto
        let useTesseractEngine = false
        
    
        var config: SBSDKOpticalCharacterRecognizerConfiguration 
        if useTesseractEngine {
            config = SBSDKOpticalCharacterRecognizerConfiguration.legacyConfiguration(withLanguageString: "de+en")
        } else {
            config = SBSDKOpticalCharacterRecognizerConfiguration.ml()
        }
        
        let options = SBSDKPDFRendererOptions(pageSize: pageSize, 
                                              pageOrientation: pageOrientation, 
                                              ocrConfiguration: config)
        
        let error = SBSDKUIPDFRenderer.renderDocument(document, with: options, output: pdfURL)
        if error == nil, let presenter = self.presenter {
            SBSDKSharingActivity.shareFiles(at: [pdfURL], presenter: presenter)
        } else {
            print("\(error?.localizedDescription ?? "")")
        }
        completion()
    }
}
