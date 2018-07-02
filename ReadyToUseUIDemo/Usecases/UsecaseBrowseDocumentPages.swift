//
//  UsecaseBrowseDocumentPages.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

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
        
        let alert = UIAlertController(title: "Edit Page",
                                      message: "Which operation do you want to perform on the page?",
                                      preferredStyle: .actionSheet)
        
        let cropAction = UIAlertAction(title: "Crop Page", style: .default) { (_) in
            UsecaseCropPage(page: page).start(presenter: viewController)
        }
        
        let filterAction = UIAlertAction(title: "Filter Page", style: .default) { (_) in
            UsecaseFilterPage(page: page).start(presenter: viewController)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cropAction)
        alert.addAction(filterAction)
        alert.addAction(cancelAction)
        
        alert.actions.forEach { (action) in
            action.setValue(UIColor.black, forKey: "titleTextColor")
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
