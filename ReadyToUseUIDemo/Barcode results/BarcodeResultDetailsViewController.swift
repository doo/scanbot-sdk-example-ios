//
//  BarcodeResultDetailsViewController.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BarcodeResultDetailsViewController: UITableViewController {
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var label: UILabel?
    
    var barcode: SBSDKBarcodeScannerResult? {
        didSet {
            if self.isViewLoaded {
                self.updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 600
        
        self.updateUI()
    }
    
    private func updateUI() {
        guard let barcode = self.barcode else { return }
        self.imageView?.image = barcode.barcodeImage
        var text = barcode.rawTextString
        
        if let rawBytes = self.barcode?.rawBytes {
            let hexString = rawBytes.map({ String(format: "%02hhx", $0) }).joined()
            text = text + "\n\nRaw bytes:\n" + hexString
        }
        
        self.label?.text = text
    }
}
