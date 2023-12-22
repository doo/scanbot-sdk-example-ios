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
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        updateUI()
    }
    
    private func updateUI() {
        guard let barcode = barcode else { return }
        imageView?.image = barcode.barcodeImage
        var text = barcode.rawTextStringWithExtension
        
        let hexString = barcode.rawBytes.map({ String(format: "%02hhx", $0) }).joined()
        text = text + "\n\nRaw bytes:\n" + hexString
        
        if let formattedText = BarcodeFormatter().formattedBarcodeText(barcode: barcode), barcode.formattedResult?.parsedSuccessful ?? false {
            text = text + formattedText
        }
        
        
        label?.text = text
    }
}
