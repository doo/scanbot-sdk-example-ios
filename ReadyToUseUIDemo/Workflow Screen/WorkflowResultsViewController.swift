//
//  WorkflowResultsViewController.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 06.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class WorkflowResultsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView?
}

class WorkflowResultsViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var textView: UITextView?
    @IBOutlet private var toPasteboardButton: UIButton?
    @IBOutlet private var closeButton: UIButton?
    
    private(set) var workflowsResults: [SBSDKUIWorkflowStepResult]
    
    init(with results: [SBSDKUIWorkflowStepResult]) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let controller = storyboard.instantiateViewController(withIdentifier: "WorkflowResultsViewController") as!
//        WorkflowResultsViewController
        workflowsResults = results
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(with: [])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateResults()
    }
    
    private func resultsText() -> String {
        var texts: [String] = []
        for result in workflowsResults {
            if let mrzResult = result.mrzResult {
                texts.append(mrzResult.stringRepresentation())
            }
            if let dcResult = result.disabilityCertificateResult {
                texts.append(dcResult.stringRepresentation())
            }
            if let barcodeResults = result.barcodeResults, barcodeResults.isEmpty != true {
                for code in barcodeResults {
                    texts.append(code.rawTextString)
                    texts.append("\n\n")
                }
            }
            if let payformResult = result.payformResult, payformResult.recognizedFields.isEmpty != true {
                for field in payformResult.recognizedFields {
                    if let stringValue = field.stringValue, stringValue.count > 0 {
                        texts.append(stringValue)
                    }
                }
            }
        }
        return texts.joined(separator: "\n\n")
    }
    
    private func updateResults() {
        collectionView?.reloadData()
        let resultsText = resultsText()
        textView?.text = resultsText
        toPasteboardButton?.isEnabled = resultsText.count > 0
    }
    
    @IBAction private func toPasteboardButtonDidPress(_ sender: Any) {
        UIPasteboard.general.string = resultsText()
    }
    
    @IBAction private func closeButtonDidPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension WorkflowResultsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workflowsResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as!
        WorkflowResultsCollectionViewCell
        let result = workflowsResults[indexPath.item]
        var image = result.thumbnail()
        if image == nil && result.step.acceptedMachineCodeTypes?.isEmpty != true {
            image = UIImage(named: "Scanbot QRCode")
        }
        cell.imageView?.image = image
        return WorkflowResultsCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.size.width - 32
        var cellWidth = CGFloat(128)
        let numItems = CGFloat(workflowsResults.count)
        if numItems == 1 {
            cellWidth = totalWidth
        } else {
            let spacing = (numItems - 1) * 10
            cellWidth = (totalWidth - spacing) / numItems
            cellWidth = max(128, cellWidth)
        }
        return CGSize(width: cellWidth, height: 128)
    }
}
