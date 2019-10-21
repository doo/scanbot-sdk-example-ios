//
//  UsecaseCropPage.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseCropPage: Usecase, SBSDKUICroppingViewControllerDelegate {
    
    private let page: SBSDKUIPage
    
    init(page: SBSDKUIPage) {
        self.page = page
        super.init()
    }

    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)
        
        let configuration = SBSDKUICroppingScreenConfiguration.default()
        configuration.uiConfiguration.backgroundColor = UIColor.darkGray
        configuration.uiConfiguration.polygonColor = UIColor.red
        configuration.uiConfiguration.polygonColorMagnetic = UIColor.blue
        //configuration.textConfiguration.cancelButtonTitle = "Cancel"
        //configuration.uiConfiguration.isDetectResetButtonHidden = true
        // Customize further colors, text resources, behavior flags ...
        
        let editor = SBSDKUICroppingViewController.createNew(with: self.page, with: configuration, andDelegate: self)
        editor.modalPresentationStyle = .fullScreen
        self.presenter?.present(editor, animated: true, completion: nil)
    }

    func croppingViewController(_ viewController: SBSDKUICroppingViewController, didFinish changedPage: SBSDKUIPage) {
        self.didFinish()
    }
    
    func croppingViewControllerDidCancel(_ viewController: SBSDKUICroppingViewController) {
        self.didFinish()
    }
}
