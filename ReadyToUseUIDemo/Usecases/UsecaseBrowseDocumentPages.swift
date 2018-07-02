//
//  UsecaseBrowseDocumentPages.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseBrowseDocumentPages: Usecase, PageReviewViewControllerDelegate {

    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }

    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let configuration = PageReviewScreenConfiguration.default()
        let browser = PageReviewViewController.createNew(with: self.document,
                                                         with: configuration,
                                                         andDelegate: self)
        self.presentViewController(browser)
    }
    
    func pageReviewViewControllerDidCancel(_ viewController: PageReviewViewController) {
        self.didFinish()
    }
    
    func pageReviewViewController(_ viewController: PageReviewViewController, didSelect page: SBSDKUIPage) {
//        UsecaseCropPage(page: page).start(presenter: viewController)
        UsecaseFilterPage(page: page).start(presenter: viewController)
    }
    
}
