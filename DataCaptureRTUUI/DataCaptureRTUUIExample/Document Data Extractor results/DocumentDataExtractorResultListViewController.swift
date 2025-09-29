//
//  DocumentDataExtractorResultListViewController.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class DocumentDataExtractorResultListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView?
    
    var results: [SBSDKDocumentDataExtractionResult] = []
    
    private var flattenedDocuments: [SBSDKGenericDocument] {
        var result: [SBSDKGenericDocument] = []
        results.forEach { documentResult in
            if let flattenedDocuments = documentResult.document?.flatDocument(includeEmptyChildren: false,
                                                              includeEmptyFields: true) {
                result.append(contentsOf: flattenedDocuments.filter({ $0.type.normalizedName != "MRZ" }))
            }
        }
        return result
    }
    
    lazy private var resultsText: String = {
        var result = ""
        flattenedDocuments.forEach { document in
            if let title = document.type.displayText {
                result += "\(title)\n"
            }
            if let allFields = document.allFields(includeEmptyFields: false) {
                allFields.forEach { field in
                    if let displayText = field.type.displayText,
                       let value = field.value,
                       !value.text.isEmpty {
                        result += "\(displayText): \(value.text)\n"
                    }
                }
            }
        }
        return result
    }()
    
    static func make(with results: [SBSDKDocumentDataExtractionResult]) -> DocumentDataExtractorResultListViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "DocumentDataExtractorResultListViewController") as! DocumentDataExtractorResultListViewController
        controller.results = results
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0
        }
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.on.doc"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didTapCopy(_:)))
        }
    }
    
    @objc private func didTapCopy(_ sender: UIBarButtonItem) {
        UIPasteboard.general.string = self.resultsText
        let alert = UIAlertController(title: "Data fields copied to clipboard",
                                      message: nil,
                                      preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension DocumentDataExtractorResultListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return flattenedDocuments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedDocuments[section].allFields(includeEmptyFields: true)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let field = flattenedDocuments[indexPath.section].allFields(includeEmptyFields: true)?[indexPath.row]
        else {
            return UITableViewCell()
        }
        if let displayText = field.type.displayText {
            if let value = field.value, !value.text.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentDataExtractorResultTextListCell",
                                                         for: indexPath) as! DocumentDataExtractorResultTextListCell
                cell.configure(title: displayText,
                               value: value.text,
                               confidence: Int(value.confidence * 100))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentDateExtractorResultImageListCell",
                                                         for: indexPath) as! DocumentDateExtractorResultImageListCell
                cell.configure(title: displayText,
                               image: field.image?.toUIImage())
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let document = flattenedDocuments[section]
        var headerName = document.type.displayText
        
        let label = UILabel(frame: CGRect(x: 15,
                                          y: 0,
                                          width: view.bounds.size.width,
                                          height: 44))
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        let categoryName = results.last?.document?.children.first?.type.displayText ?? ""
        if section >= 2 && !categoryName.isEmpty {
            headerName = categoryName + " -> " + (document.type.displayText ?? "")
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        label.text = headerName
        
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let field = flattenedDocuments[indexPath.section].allFields(includeEmptyFields: true)?[indexPath.row],
              let fieldTypeText = field.type.displayText else {
                  return 0
              }
        if let value = field.value, !value.text.isEmpty {
            return max(44, calculateTextCellHeight(valueText: value.text, typeText: fieldTypeText))
        } else {
            guard let image = field.image?.toUIImage() else { return 0 }
            return calculatedImageCellHeight(image)
        }
    }
    
    private func calculateTextCellHeight(valueText: String, typeText: String) -> CGFloat {
        
        let valueTextHeight = valueText.height(withConstrainedWidth: 123,
                                               font: UIFont.systemFont(ofSize: 16, weight: .regular))
        let typeText = typeText.height(withConstrainedWidth: 123,
                                       font: UIFont.systemFont(ofSize: 16, weight: .medium))
        return max(typeText, valueTextHeight) + 12
    }
    
    private func calculatedImageCellHeight(_ image: UIImage) -> CGFloat {
        if image.size.height < image.size.width {
            return min(image.size.height, 50)
        } else {
            return min(image.size.height, 180)
        }
    }
}

private extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
