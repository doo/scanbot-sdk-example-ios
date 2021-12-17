//
//  MainNavigationController.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 17.12.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override var shouldAutorotate: Bool {
        return self.visibleViewController?.shouldAutorotate ?? true
    }
}
