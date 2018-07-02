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
        self.title = "Scanbot SDK Demo"
        guard let navigationController = self.navigationController else {
            fatalError("Missing UINavigationController.")
        }
        navigationController.delegate = self
        let actionHandler = MainTableActionHandler(presenter: navigationController)
        self.itemProvider = MainTableViewItemProvider(actionHandler: actionHandler)
        self.tableView.reloadData()
    }
}

//MARK: UINavigationControllerDelegate
extension MainViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        
        let barHidden = (viewController != self)
        navigationController.setNavigationBarHidden(barHidden, animated: true)
    }
}


//MARK: UITableViewDatasource
extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.itemProvider.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemProvider.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.itemProvider.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = item.title
        return cell
    }
}

//MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.itemProvider.sections[indexPath.section].items[indexPath.row]
        item.action()
    }
}
