//
//  UsecaseBrowseDocumentPages.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseBrowseDocumentPages: Usecase {

    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }

    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
                
        let viewController = DocumentReviewViewController.make(with: self.document)
        if let presenter = presenter as? UINavigationController {
            presenter.pushViewController(viewController, animated: true)
        }
    }
}
