//
//  MainViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 22.10.24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ExampleCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = ExampleCategory.allCases[section]
        return category.examples.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ExampleCategory.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell",
                                                    for: indexPath) as? MainTableViewCell {
            let category = ExampleCategory.allCases[indexPath.section]
            cell.titleLabel.text = String(String(describing: category.examples[indexPath.row]).dropLast(14))
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ExampleCategory.allCases[indexPath.section]
        let viewController = category.examples[indexPath.row].init()
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
