//
//  ScanResultViewController.swift
//  ScanbotSDKDemo
//
//  Created by Dmytro Makarenko on 1/14/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit

final class ScanResultViewController: DemoViewController {
    @IBOutlet private weak var resultImageView: UIImageView!
    var resultImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultImageView.image = resultImage
    }
}
