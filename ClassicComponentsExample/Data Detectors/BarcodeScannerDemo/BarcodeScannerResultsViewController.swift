//
//  BarcodeScannerResultsViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BarcodeScannerResultsViewController: UIViewController {
    var results: [SBSDKBarcodeScannerResult]?
    
    private var selectedBarcodeImage: UIImage?
    private var selectedBarcodeText: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BarcodeResultDetailsViewController {
            controller.barcodeImage = selectedBarcodeImage
            controller.barcodeText = selectedBarcodeText
        }
    }
}

extension BarcodeScannerResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeScannerResultsTableViewCell
        
        cell.barcodeTextLabel?.text = results?[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = results?[indexPath.row].type.name
        cell.barcodeImageView?.image = results?[indexPath.row].barcodeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBarcodeImage = results?[indexPath.row].barcodeImage
        selectedBarcodeText = results?[indexPath.row].rawTextStringWithExtension
        
        performSegue(withIdentifier: "barcodeResultDetails", sender: nil)
    }
}
