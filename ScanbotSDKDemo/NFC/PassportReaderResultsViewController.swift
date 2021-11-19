//
//  PassportReaderResultsViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 18.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class PassportReaderResultsViewController: UIViewController {
    private(set) var datagroups: [SBSDKNFCDatagroup]!
    @IBOutlet private var tableView: UITableView?
    
    static func make(with datagroups: [SBSDKNFCDatagroup]) -> PassportReaderResultsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PassportReaderResultsViewController")
        as! PassportReaderResultsViewController
        controller.datagroups = datagroups
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.reloadData()
    }
}

extension PassportReaderResultsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datagroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(datagroups?[section].numberOfElements() ?? 0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datagroups?[section].type ?? ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = datagroups[indexPath.section]
        if let value = group.value(at: UInt(indexPath.row)) as? Data {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as!
            PassportReaderResultImageTableViewCell
            
            let image = UIImage(data: value)
            cell.photoView?.image = image
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as!
            PassportReaderResultTextTableViewCell
            
            cell.keyLabel?.text = group.key(at: UInt(indexPath.row))
            if let value = group.value(at: UInt(indexPath.row)) as? NSNumber {
                cell.valueLabel?.text = value.stringValue.isEmpty ? "---" : value.stringValue
            } else if let value = group.value(at: UInt(indexPath.row)) as? String {
                cell.valueLabel?.text = value.isEmpty ? "---" : value
            }
            return cell
        }
    }
}
