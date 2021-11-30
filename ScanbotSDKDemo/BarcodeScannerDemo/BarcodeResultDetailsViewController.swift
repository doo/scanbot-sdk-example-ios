//
//  BarcodeResultDetailsViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

final class BarcodeResultDetailsViewController: UIViewController {
    
    var barcodeImage: UIImage?
    var barcodeText: String?
    
    @IBOutlet private var barcodeImageView: UIImageView?
    @IBOutlet private var barcodeTextLabel: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barcodeImageView?.image = barcodeImage
        barcodeTextLabel?.text = barcodeText
    }
}
