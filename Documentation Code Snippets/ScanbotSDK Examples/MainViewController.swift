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
            cell.titleLabel.text = Self.title(for: category.examples[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    private static func title(for example: UIViewController.Type) -> String {
        let name = String(describing: example)
        
        guard let start = name.firstIndex(of: "<"), let end = name.lastIndex(of: ">") else {
            return String(name.dropLast("ViewController".count))
        }
        
        var base = String(name[name.index(after: start)..<end])
        for suffix in ["SwiftUIScannerView", "SwiftUIView"] where base.hasSuffix(suffix) {
            base = String(base.dropLast(suffix.count))
            break
        }
        return "\(base) (SwiftUI)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = ExampleCategory.allCases[indexPath.section]
        let viewController = category.examples[indexPath.row].init()
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
