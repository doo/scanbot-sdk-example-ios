//
//  MultipleObjectsDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class MultipleObjectsDemoViewController: UIViewController {
    private var scannerViewController: SBSDKMultipleObjectScannerViewController?
    private var imageProcessor = SBSDKBusinessCardsImageProcessor()
    
    private var selectedImage: UIImage?
    private var selectedText: String?
    
    private var ocrResults: [SBSDKOCRResult]?
    private var storage: SBSDKIndexedImageStorage?
    private var isProcessing: Bool = false
    
    @IBOutlet private var closeCollectionContainerButton: UIButton?
    @IBOutlet private var collectionContainerHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKMultipleObjectScannerViewController(parentViewController: self, parentView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MultipleObjectsDetailDemoViewController {
            destination.imageView?.image = selectedImage
            destination.textView?.text = selectedText
        }
    }
    
    private func processDetectDocuments(in storage: SBSDKIndexedImageStorage) {
        showLoadingView()
        isProcessing = true
        imageProcessor.processImageStorage(storage,
                                           ocrLanguages: "en+de") { [weak self] processedStorage, results in
            guard let self = self else { return }
            self.storage = processedStorage as? SBSDKIndexedImageStorage
            self.ocrResults = results
            self.collectionView?.reloadData()
            self.hideLoadingView()
            if processedStorage.imageCount > 0 {
                self.openCollectionContainer()
            }
            self.isProcessing = false
        }
    }
    
    private func openCollectionContainer() {
        collectionContainerHeightConstraint?.constant = 450
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func closeCollectionContainer() {
        collectionContainerHeightConstraint?.constant = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func showLoadingView() {
        loadingView?.alpha = 0
        loadingView?.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loadingView?.alpha = 1.0
        }
    }
    
    private func hideLoadingView() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loadingView?.alpha = 0.0
        } completion: { [weak self] _ in
            self?.loadingView?.isHidden = true
        }
    }
    
    private func isPanelOpened() -> Bool {
        return collectionContainerHeightConstraint?.constant ?? 0 > 0
    }
    
    @IBAction private func closeCollectionViewButtonDidPress(_ sender: Any) {
        closeCollectionContainer()
    }
}

extension MultipleObjectsDemoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(storage?.imageCount ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessCardCell", for: indexPath) as!
        MultipleObjectsDemoCell
        cell.imageView?.image = storage?.image(at: UInt(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedImage = storage?.image(at: UInt(indexPath.row))
        selectedText = ocrResults?[indexPath.row].recognizedText
        return true
    }
}

extension MultipleObjectsDemoViewController: SBSDKMultipleObjectScannerViewControllerDelegate {
    func scannerController(_ controller: SBSDKMultipleObjectScannerViewController,
                           didCaptureOriginalImage originalImage: UIImage) {
        
    }
    
    func scannerController(_ controller: SBSDKMultipleObjectScannerViewController,
                           didCaptureObjectImagesInStorage imageStorage: SBSDKImageStoring) {
        guard let imageStorage = imageStorage as? SBSDKIndexedImageStorage else { return }
        processDetectDocuments(in: imageStorage)
    }
    
    func scannerControllerWillCaptureImage(_ controller: SBSDKMultipleObjectScannerViewController) {
        storage?.removeAllImages()
    }
    
    func scannerControllerShouldAnalyseVideoFrame(_ controller: SBSDKMultipleObjectScannerViewController) -> Bool {
        return isPanelOpened() == false && isProcessing == false
    }
}
