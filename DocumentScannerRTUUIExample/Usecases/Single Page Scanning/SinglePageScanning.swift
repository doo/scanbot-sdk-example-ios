//
//  SinglePageScanning.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 04.09.23.
//

import ScanbotSDK

final class SinglePageScanning: NSObject, SBSDKUIDocumentScannerViewControllerDelegate {
    
    // The view controller on which the scanner is presented on
    private var presenter: UIViewController?
    
    init(presenter: UIViewController? = nil) {
        self.presenter = presenter
    }
    
    // The scanner view controller calls this delegate method when it has scanned document pages
    // and the scanner view controller has been dismissed
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKDocument) {
        
        // Process the document
        let resultViewController = SingleScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    // The scanner view controller calls this delegate method to inform that it has been cancelled and dismissed
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        
    }
}

extension SinglePageScanning {
    
    // To hold an instance of the delegate handler
    private static var delegateHandler: MultiplePageScanning?
    
    static func present(presenter: UIViewController) {
        
        // Initialize delegate handler
        delegateHandler = MultiplePageScanning(presenter: presenter)
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUIDocumentScannerConfiguration.defaultConfiguration
        
        // Disable the multiple page behavior
        configuration.behaviorConfiguration.isMultiPageEnabled = false
        
        // Enable Auto Snapping behavior
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        // Hide the multiple page enable/disable button
        configuration.uiConfiguration.isMultiPageButtonHidden = true
        
        // Hide the auto snapping enable/disable button
        configuration.uiConfiguration.isAutoSnappingButtonHidden = true
        
        // Set colors
        configuration.uiConfiguration.topBarBackgroundColor = .appAccentColor
        configuration.uiConfiguration.topBarButtonsInactiveColor = .white
        configuration.uiConfiguration.bottomBarBackgroundColor = .appAccentColor
        configuration.uiConfiguration.bottomBarButtonsColor = .white
        
        // Set the font for the hint text
        configuration.textConfiguration.textHintFontSize = 16.0
        
        // Configure the hint texts for different scenarios
        configuration.textConfiguration.textHintTooDark = "Need more lighting to detect a document"
        configuration.textConfiguration.textHintTooSmall = "Document too small"
        configuration.textConfiguration.textHintNothingDetected = "Could not detect a document"
        
        // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
        SBSDKUIDocumentScannerViewController.present(on: presenter,
                                                     configuration: configuration,
                                                     delegate: delegateHandler)
    }
}
