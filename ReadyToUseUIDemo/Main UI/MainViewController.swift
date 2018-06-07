//
//  MainViewController.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var itemProvider: MainTableViewItemProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ScanbotSDK ReadyToUseUI"
        let actionHandler = MainTableActionHandler(presenter: self)
        self.itemProvider = MainTableViewItemProvider(actionHandler: actionHandler)
        self.tableView.reloadData()
    }
}

//MARK: UITableViewDatasource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemProvider.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.itemProvider.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }
}

//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.itemProvider.items[indexPath.row]
        item.action()
    }
}
