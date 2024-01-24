//
//  GenericDocumentResultViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class GenericDocumentResultViewController: UIViewController {
    var document: SBSDKGenericDocument?
    var flatDocument: [SBSDKGenericDocument]?
    var sourceImage: UIImage?
    @IBOutlet var tableView: UITableView?
    
    static func make(with document: SBSDKGenericDocument, sourceImage: UIImage) -> GenericDocumentResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GenericDocumentResultViewController") as!
        GenericDocumentResultViewController
        controller.document = document
        controller.sourceImage = sourceImage
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flatDocument = document?.flatDocument(includeEmptyChildren: false, includeEmptyFields: false)
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 100.0
        tableView?.reloadData()
    }
    
    @IBAction private func shareSourceImage(_ sender: Any) {
        guard let sourceImage = sourceImage else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [sourceImage]
                                                              , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func text(for type: SBSDKGenericDocumentType) -> String {
        if let displayText = type.displayText {
            return displayText
        }
        return type.name
    }
}

extension GenericDocumentResultViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return flatDocument?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return flatDocument?[section].type.displayText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flatDocument?[section].fields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as!
        GenericDocumentFieldTableViewCell
        let field = flatDocument?[indexPath.section].fields[indexPath.row]
        cell.fieldTypeLabel.text = field?.type.name
        
        let image = field?.image?.sbsdk_limited(to: CGSize(width: 10000.0, height: 80.0))
        cell.fieldImageView.image = image
        
        if let value = field?.value, value.text.isEmpty == false {
            cell.recognizedTextLabel.text = value.text
            cell.recognizedTextInfoLabel.text = "Recognized text with confidence\(value.confidence * 100)"
        } else {
            cell.recognizedTextLabel.text = ""
            cell.recognizedTextInfoLabel.text = ""
        }
        return cell
    }
}
