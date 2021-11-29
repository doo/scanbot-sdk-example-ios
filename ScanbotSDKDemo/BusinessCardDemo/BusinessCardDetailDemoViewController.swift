//
//  BusinessCardDetailDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class BusinessCardDetailDemoViewController: UIViewController {
        
    var image: UIImage? {
        didSet {
            updateView()
        }
    }
    var text: String? {
        didSet {
            updateView()
        }
    }
    
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    private func updateView() {
        if isViewLoaded {
            imageView?.image = image
            textView?.text = text
        }
    }
}
