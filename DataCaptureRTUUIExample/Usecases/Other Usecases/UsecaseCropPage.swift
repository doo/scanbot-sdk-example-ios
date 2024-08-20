//
//  UsecaseCropPage.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseCropPage: Usecase, SBSDKUICroppingViewControllerDelegate {
    
    private let page: SBSDKDocumentPage
    private let didFinishHandler: ()->()
    
    init(page: SBSDKDocumentPage, didFinishHandler: @escaping ()->()) {
        self.page = page
        self.didFinishHandler = didFinishHandler
        super.init()
    }

    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUICroppingScreenConfiguration.defaultConfiguration
        configuration.uiConfiguration.backgroundColor = UIColor.darkGray
        configuration.uiConfiguration.polygonColor = UIColor.red
        configuration.uiConfiguration.polygonColorMagnetic = UIColor.blue
        //configuration.textConfiguration.cancelButtonTitle = "Cancel"
        //configuration.uiConfiguration.isDetectResetButtonHidden = true
        // Customize further colors, text resources, behavior flags ...
        
        let editor = SBSDKUICroppingViewController.create(page: page, configuration: configuration, delegate: self)
        editor.modalPresentationStyle = .fullScreen
        presenter.present(editor, animated: true, completion: nil)
    }

    func croppingViewController(_ viewController: SBSDKUICroppingViewController, didFinish changedPage: SBSDKDocumentPage) {
        didFinishHandler()
        didFinish()
    }
    
    func croppingViewControllerDidCancel(_ viewController: SBSDKUICroppingViewController) {
        didFinish()
    }
}
