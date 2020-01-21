//
//  UIImageViewExtensions.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 03.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

extension UIImageView {
    @objc func setImageAnimated(_ image: UIImage?) {
        self.image = image
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.layer.add(transition, forKey: nil)
    }
}

