//
//  ReviewDocumentsViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 04.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class ReviewDocumentsViewController: UIViewController {
    
    var documentImageStorage: SBSDKIndexedImageStorage?
        
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var importButton: UIBarButtonItem?
    @IBOutlet private var deleteAllButton: UIBarButtonItem?
    @IBOutlet private var exportButton: UIBarButtonItem?
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        toolbar?.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @IBAction private func importButtonDidPress(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    @IBAction private func deleteAllButtonDidPress(_ sender: Any) {
        documentImageStorage?.removeAllImages()
        reloadData()
    }
    
    @IBAction private func exportButtonDidPress(_ sender: Any) {
        guard let documentImageStorage = documentImageStorage else { return }
        activityIndicator?.startAnimating()
        DispatchQueue(label: "ExportToPDF_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            do {
                let pdf = try SBSDKPDFRenderer.renderImageStorage(documentImageStorage,
                                                                  indexSet: nil,
                                                                  with: .auto,
                                                                  output: url)
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator?.stopAnimating()
                    self?.sharePDF(at: pdf)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator?.stopAnimating()
                }
                print("Failed to render PDF. Description: \(error.localizedDescription)")
            }
        }
    }
    
    private func reloadData() {
        collectionView?.reloadData()
        [importButton, deleteAllButton, exportButton]
            .forEach({ $0?.isEnabled = (documentImageStorage?.imageCount ?? 0) > 0 })
    }
        
    private func sharePDF(at url: URL) {
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = exportButton?.customView
        controller.popoverPresentationController?.sourceRect = exportButton?.customView?.bounds ?? .zero
        present(controller, animated: true, completion: nil)
    }
}

extension ReviewDocumentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(documentImageStorage?.imageCount ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = documentImageStorage?.image(at: UInt(indexPath.item))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCollectionCell",
                                                      for: indexPath) as! ReviewDocumentsCollectionViewCell
        cell.previewImageView?.image = image
        return cell
    }
}

extension ReviewDocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            documentImageStorage?.add(image)
            reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
