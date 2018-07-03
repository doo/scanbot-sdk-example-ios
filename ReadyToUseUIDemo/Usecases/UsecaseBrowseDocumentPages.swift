//
//  UsecaseBrowseDocumentPages.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

enum BrowseDocumentMode {
    case viewing
    case scanning
    case importing
}

class UsecaseBrowseDocumentPages: Usecase, PageReviewViewControllerDelegate {

    private let document: SBSDKUIDocument
    private let mode: BrowseDocumentMode
    private var browser: PageReviewViewController?
    
    init(document: SBSDKUIDocument, mode: BrowseDocumentMode) {
        self.document = document
        self.mode = mode
        super.init()
    }

    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let configuration = PageReviewScreenConfiguration.default()
        switch self.mode {
        case .viewing:
            configuration.textConfiguration.topLeftButtonTitle = "Back"
            configuration.textConfiguration.topRightButtonTitle = nil
        case .scanning:
            configuration.textConfiguration.topLeftButtonTitle = "Scan"
            configuration.textConfiguration.topRightButtonTitle = "Done"
        case .importing:
            configuration.textConfiguration.topLeftButtonTitle = "Import"
            configuration.textConfiguration.topRightButtonTitle = "Done"
        }
        
        let browser = PageReviewViewController.createNew(with: self.document,
                                                         with: configuration,
                                                         andDelegate: self)
        self.browser = browser
        self.presentViewController(browser)
        self.showImagePickerIfNeeded(browser)
    }
    
    private func showImagePickerIfNeeded(_ viewController: UIViewController) {
        if self.mode == .importing {
            UsecaseImportImage(document: self.document).start(presenter: viewController)
        }
    }
    
    func pageReviewViewControllerDidCancel(_ viewController: PageReviewViewController) {
        self.didFinish()
    }
    
    func pageReviewViewControllerDidPressBottomButton(_ viewController: PageReviewViewController) {
        let alert = UIAlertController(title: "Delete All Scans?",
                                      message: "Do you want to delete all scanned pages?",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            viewController.deleteAllPages()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pageReviewViewControllerDidPressTopLeftButton(_ viewController: PageReviewViewController) {
        switch self.mode {
        case .viewing:
            viewController.dismiss(true)
        case .scanning:
            if let navigationController = self.presenter as? UINavigationController {
                navigationController.popViewController(animated: true)
            }
        case .importing:
            UsecaseImportImage(document: self.document).start(presenter: viewController)
        }
    }
    
    func pageReviewViewControllerDidPressTopRightButton(_ viewController: PageReviewViewController) {
        switch self.mode {
        case .scanning:
            if let navigationController = self.presenter as? UINavigationController {
                navigationController.popToRootViewController(animated: true)
            }
        default:
            viewController.dismiss(true)
        }
    }
    
    func pageReviewViewController(_ viewController: PageReviewViewController, didSelect page: SBSDKUIPage) {
        
        let alert = UIAlertController(title: "Edit Page",
                                      message: "Which operation do you want to perform on the page?",
                                      preferredStyle: .actionSheet)
        
        let cropAction = UIAlertAction(title: "Crop/Rotate Page", style: .default) { (_) in
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
