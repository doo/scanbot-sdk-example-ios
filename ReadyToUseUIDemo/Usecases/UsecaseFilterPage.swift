//
//  UsecaseFilterPage.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseFilterPage: Usecase, FilteringViewControllerDelegate {
    
    private let page: SBSDKUIPage
    
    init(page: SBSDKUIPage) {
        self.page = page
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let configuration = FilteringScreenConfiguration.default()
        let editor = FilteringViewController.createNew(with: self.page, with: configuration, andDelegate: self)
        self.presenter?.present(editor, animated: true, completion: nil)
    }

    func filteringViewController(_ viewController: FilteringViewController, didFinish changedPage: SBSDKUIPage) {
        self.didFinish()
    }

    func filteringViewControllerDidCancel(_ viewController: FilteringViewController) {
        self.didFinish()
    }
}
