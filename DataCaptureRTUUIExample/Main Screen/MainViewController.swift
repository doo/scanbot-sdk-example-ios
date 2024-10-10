//
//  MainViewController.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private var itemProvider: MainTableViewItemProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scanbot SDK Demo"
        guard let navigationController = navigationController else {
            fatalError("Missing UINavigationController.")
        }
        navigationController.delegate = self
        let actionHandler = MainTableActionHandler(presenter: navigationController)
        itemProvider = MainTableViewItemProvider(actionHandler: actionHandler)
        tableView.reloadData()
    }
}

//MARK: UITableViewDatasource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return itemProvider.sections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemProvider.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemProvider.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemProvider.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }
}

//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = itemProvider.sections[indexPath.section].items[indexPath.row]
        item.action()
    }
}
