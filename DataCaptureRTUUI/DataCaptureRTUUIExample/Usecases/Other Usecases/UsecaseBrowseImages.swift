//
//  UsecaseBrowseImages.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseBrowseImages: Usecase {

    private let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
        super.init()
    }

    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
                
        if let presenter = presenter as? UINavigationController {
            let viewController = ReviewViewController.make(with: result)
            presenter.pushViewController(viewController, animated: true)
        }
    }
}
