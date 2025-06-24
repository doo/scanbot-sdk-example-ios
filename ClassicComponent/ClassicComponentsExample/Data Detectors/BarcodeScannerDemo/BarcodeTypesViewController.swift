//
//  BarcodeTypesViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

protocol BarcodeTypesViewControllerDelegate: AnyObject {
    func barcodeTypesListViewController(_ controller: BarcodeTypesViewController,
                                        didFinishSelectingWith types: [SBSDKBarcodeFormat])
}

final class BarcodeTypesViewController: UITableViewController {
        
    weak var delegate: BarcodeTypesViewControllerDelegate?
    
    var selectedTypes: [SBSDKBarcodeFormat] = []
    private var allTypes = SBSDKBarcodeFormats.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedTypes.isEmpty {
            selectedTypes = allTypes
        }
    }
    
    @IBAction func applyButtonDidPress(_ sender: Any) {
        delegate?.barcodeTypesListViewController(self, didFinishSelectingWith: selectedTypes)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barcodeTypesListCell", for: indexPath)
        let type = allTypes[indexPath.row]
        cell.textLabel?.text = type.name
        cell.accessoryType = selectedTypes.contains(type) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = allTypes[indexPath.row]
        if let index = selectedTypes.firstIndex(of: type) {
            selectedTypes.remove(at: index)
        } else {
            selectedTypes.append(type)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
