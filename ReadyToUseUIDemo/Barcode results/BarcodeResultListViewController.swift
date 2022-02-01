//
//  BarcodeResultListViewController.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BarcodeResultListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var noBarcodesView: UIView?
    
    var barcodeImage: UIImage? {
        didSet {
            if isViewLoaded {
                reloadData()
            }
        }
    }
    
    var barcodes: [SBSDKBarcodeScannerResult] = [] {
        didSet {
            if isViewLoaded {
                reloadData()
            }
        }
    }
    
    private var selectedBarcode: SBSDKBarcodeScannerResult?
    
    private let imageSection = 0
    private let listSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    static func make(with barcodes: [SBSDKBarcodeScannerResult]) -> BarcodeResultListViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "BarcodeResultListViewController") as! BarcodeResultListViewController
        controller.barcodes = barcodes
        
        return controller
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BarcodeResultDetailsViewController",
           let destination = segue.destination as? BarcodeResultDetailsViewController,
           let selectedBarcode = self.selectedBarcode {
            
            destination.barcode = selectedBarcode
        }
    }
    
    private func reloadData() {
        noBarcodesView?.isHidden = !barcodes.isEmpty
        tableView?.reloadData()
    }
}

extension BarcodeResultListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == imageSection {
            return 250
        }
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == imageSection {
            return barcodeImage == nil ? 0 : 1
        }
        return barcodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == imageSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BarcodeResultListCellImage",
                                                     for: indexPath) as! BarcodeResultListCell
            cell.barcodeImageView?.image = barcodeImage
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarcodeResultListCell",
                                                 for: indexPath) as! BarcodeResultListCell
        let barcode = barcodes[indexPath.row]
        cell.infoLabel?.text = barcode.rawTextString
        cell.typeLabel?.text = barcode.type.name
        cell.barcodeImageView?.image = barcode.barcodeImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == imageSection {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBarcode = barcodes[indexPath.row]
        performSegue(withIdentifier: "BarcodeResultDetailsViewController", sender: self)
    }
}
