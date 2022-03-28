//
//  DocumentReviewViewController.swift
//  ReadyToUseUIDemo
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
    @IBOutlet private var blurButton: UIBarButtonItem!
    @IBOutlet private var clearButton: UIBarButtonItem?
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    var document: SBSDKUIDocument!
    
    private static var showsBlurriness: Bool = false
    private static let blurinessCache = NSCache<NSURL, NSNumber>()
    
    private var showsBlurriness: Bool = showsBlurriness {
        didSet {
            Self.showsBlurriness = showsBlurriness
            if isViewLoaded { reloadData() }
        }
    }
    
    class func make(with document: SBSDKUIDocument) -> DocumentReviewViewController {
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
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction private func filterButtonDidPress(_ sender: Any) {
        UsecaseFilterPage(document: self.document, completion: { [weak self] in
            self?.reloadData()
        }).start(presenter: self)
    }
    
    @IBAction private func blurButtonDidPress(_ sender: Any) {
        showsBlurriness.toggle()
    }
    
    @IBAction private func clearButtonDidPress(_ sender: Any) {
        while document.numberOfPages() > 0 {
            document.removePage(at: 0)
        }
        SBSDKUIPageFileStorage.default().removeAll()
        reloadData()
    }
    
    private func reloadData() {
        collectionView?.reloadData()
        [exportButton, filterButton, blurButton, clearButton]
            .forEach({ $0?.isEnabled = document.numberOfPages() > 0 })
    }
    
    private func calculateBlurrinessFor(_ item: Int) {
        DispatchQueue(label: "FilterQueue").async { [weak self] in
            if let image = self?.document.page(at: item)?.originalImage(),
               let url = self?.document.page(at: item)?.originalImageURL() {
                
                let blurriness = SBSDKBlurrinessEstimator().estimateImageBlurriness(image)
                Self.blurinessCache.setObject(NSNumber(value: blurriness), forKey: url as NSURL)
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadItems(at: [IndexPath(item: item, section: 0)])
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DocumentReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return document.numberOfPages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentReviewCollectionViewCell", for: indexPath) as!
        DocumentReviewCollectionViewCell
        let page = document.page(at: indexPath.item)
        cell.previewImageView?.image = page?.documentImage()
        if showsBlurriness {
            if let imageURL = document.page(at: indexPath.item)?.originalImageURL() {
                if let bluriness = Self.blurinessCache.object(forKey: imageURL as NSURL)?.doubleValue {
                    cell.infoLabelText = String(format: "Blur = %0.2f", bluriness)
                } else {
                    cell.infoLabelText = "Calculating..."
                    self.calculateBlurrinessFor(indexPath.item)
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
