//
//  DocumentDataExtractorResultViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class DocumentDataExtractorResultViewController: UIViewController {
    var document: SBSDKGenericDocument?
    var flatDocument: [SBSDKGenericDocument]?
    var sourceImage: SBSDKImageRef?
    @IBOutlet var tableView: UITableView?
    
    static func make(with document: SBSDKGenericDocument, sourceImage: SBSDKImageRef) -> DocumentDataExtractorResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DocumentDataExtractorResultViewController") as!
        DocumentDataExtractorResultViewController
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

extension DocumentDataExtractorResultViewController: UITableViewDataSource {
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
        
        if let image = field?.image {
            let processor = SBSDKImageProcessor()
            let processedImage = try? processor.limitSizeToSize(image, sizeLimit: CGSize(width: 10000.0, height: 80.0))
            cell.fieldImageView.image = try? processedImage?.toUIImage()
        }
        
        if let value = field?.value, value.text.isEmpty == false {
            cell.extractedTextLabel.text = value.text
            cell.extractedTextInfoLabel.text = "Extracted text with confidence\(value.confidence * 100)"
        } else {
            cell.extractedTextLabel.text = ""
            cell.extractedTextInfoLabel.text = ""
        }
        return cell
    }
}
