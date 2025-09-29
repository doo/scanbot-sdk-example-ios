//
//  BannerUITableViewCell.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 31.08.23.
//

import UIKit

class BannerUITableViewCell: UITableViewCell {
    
    @IBAction func contactSupportTapped(_ sender: UIButton) {
        if let url = URL(string: "https://docs.scanbot.io/support/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func getLicenseTapped(_ sender: UIButton) {
        if let url = URL(string: "https://scanbot.io/trial/") {
            UIApplication.shared.open(url)
        }
    }
}

