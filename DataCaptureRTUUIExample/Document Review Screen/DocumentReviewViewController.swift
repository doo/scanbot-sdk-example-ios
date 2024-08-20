//
//  DocumentReviewViewController.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 07.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class DocumentReviewViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var importButton: UIBarButtonItem?
    @IBOutlet private var exportButton: UIBarButtonItem?
    @IBOutlet private var filterButton: UIBarButtonItem?
    @IBOutlet private var qualityButton: UIBarButtonItem!
    @IBOutlet private var clearButton: UIBarButtonItem?
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    var document: SBSDKDocument!
    
    private static var showsQuality: Bool = false
    private static var qualityCache = [URL: SBSDKDocumentQuality]()
    
    private var showsQuality: Bool = showsQuality {
        didSet {
            Self.showsQuality = showsQuality
            if isViewLoaded { reloadData() }
        }
    }
    
    class func make(with document: SBSDKDocument) -> DocumentReviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DocumentReviewViewController")
        as! DocumentReviewViewController
        viewController.document = document
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        toolbar?.isTranslucent = false
        reloadData()
    }
    
    @IBAction private func importButtonDidPress(_ sender: Any) {
        UsecaseImportImage(document: document) {
            self.reloadData()
        }.start(presenter: self)
    }
    
    @IBAction private func exportButtonDidPress(_ sender: UIBarButtonItem) {
        UsecaseExportImage(document: document, barButtonItem: sender) { [weak self] in
            self?.activityIndicator?.startAnimating()
        } completionHandler: { [weak self] error, url in
            self?.activityIndicator?.stopAnimating()
            guard let url = url else {
                print("Failed to render Document. Description: \(error?.localizedDescription ?? "")")
                return
            }
            self?.shareFile(at: url)
        }.start(presenter: self)
    }
    
    private func shareFile(at url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = self.exportButton
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction private func filterButtonDidPress(_ sender: UIBarButtonItem?) {
        UsecaseFilterPage(document: self.document, barButtonItem: sender, completion: { [weak self] in
            self?.reloadData()
        }).start(presenter: self)
    }
    
    @IBAction private func qualityButtonDidPress(_ sender: Any) {
        showsQuality.toggle()
    }
    
    @IBAction private func clearButtonDidPress(_ sender: Any) {
        while document.pages.count > 0 {
            document.removePage(at: 0)
        }
        SBSDKDocumentPageFileStorage.defaultStorage.removeAll()
        reloadData()
    }
    
    private func reloadData() {
        collectionView?.reloadData()
        [exportButton, filterButton, qualityButton, clearButton]
            .forEach({ $0?.isEnabled = document.pages.count > 0 })
    }
    
    private func calculateQualityFor(_ item: Int) {
        DispatchQueue(label: "FilterQueue").async { [weak self] in
            if let image = self?.document.page(at: item)?.originalImage,
               let url = self?.document.page(at: item)?.originalImageURL {
                
                let quality = SBSDKDocumentQualityAnalyzer().analyze(on: image)
                Self.qualityCache[url] = quality
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadItems(at: [IndexPath(item: item, section: 0)])
            }
        }
    }
}

extension SBSDKDocumentQuality {
    var stringValue: String {
        switch self {
        case .noDocument:
            return "No Document"
        case .veryPoor:
            return "Very Poor"
        case .poor:
            return "Poor"
        case .reasonable:
            return "Reasonable"
        case .good:
            return "Good"
        case .excellent:
            return "Excellent"
        @unknown default:
            return ""
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DocumentReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return document.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentReviewCollectionViewCell", for: indexPath) as!
        DocumentReviewCollectionViewCell
        let page = document.page(at: indexPath.item)
        cell.previewImageView?.image = page?.documentImage
        if showsQuality {
            if let imageURL = document.page(at: indexPath.item)?.originalImageURL {
                if let quality = Self.qualityCache[imageURL] {
                    cell.infoLabelText = String(format: "Q: \(quality.stringValue)")
                } else {
                    cell.infoLabelText = "Calculating..."
                    self.calculateQualityFor(indexPath.item)
                }
            }
        } else {
            cell.infoLabelText = nil
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DocumentReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = document.page(at: indexPath.item) {
            UsecaseCropPage(page: page) { [weak self] in
                self?.reloadData()
            }.start(presenter: self)
        }
    }
}
