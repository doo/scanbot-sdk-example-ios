//
//  BusinessCardDetailDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class BusinessCardDetailDemoViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var textView: UITextView?
    
    func update(with image: UIImage?, text: String) {
        if isViewLoaded {
            imageView?.image = image
            textView?.text = text
        }
    }
}
