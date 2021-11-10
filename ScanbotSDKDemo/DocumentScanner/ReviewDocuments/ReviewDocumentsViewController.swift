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
    var originalImageStorage: SBSDKIndexedImageStorage?

    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var importButton: UIBarButtonItem?
    @IBOutlet private var deleteAllButton: UIBarButtonItem?
    @IBOutlet private var exportButton: UIBarButtonItem?
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?

    private var selectedImageIndex: Int?
    
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
        originalImageStorage?.removeAllImages()
        reloadData()
    }
    
    @IBAction private func exportButtonDidPress(_ sender: Any) {
        guard let documentImageStorage = documentImageStorage else { return }
        activityIndicator?.startAnimating()
        DispatchQueue(label: "exportToPDF_queue").async {
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

extension ReviewDocumentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = originalImageStorage?.image(at: UInt(indexPath.item)) else { return }
        
        selectedImageIndex = indexPath.item
        
        let editingViewController = SBSDKImageEditingViewController()
        editingViewController.image = image
        editingViewController.delegate = self
        
        navigationController?.pushViewController(editingViewController, animated: true)
    }
}

extension ReviewDocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        documentImageStorage?.add(image)
        originalImageStorage?.add(image)
        reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ReviewDocumentsViewController: SBSDKImageEditingViewControllerDelegate {
    func imageEditingViewController(_ editingViewController: SBSDKImageEditingViewController,
                                    didApplyChangesWith polygon: SBSDKPolygon,
                                    croppedImage: UIImage) {
        guard let selectedImageIndex = selectedImageIndex else { return }
        
        documentImageStorage?.replaceImage(at: UInt(selectedImageIndex), with: croppedImage)
        editingViewController.navigationController?.popViewController(animated: true)
    }
    
    func imageEditingViewControllerApplyButtonItem(
        _ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
        return UIBarButtonItem(title: "Apply", style: .done, target: nil, action: nil)
    }
    
    func imageEditingViewControllerRotateClockwiseToolbarItem(
        _ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
            return UIBarButtonItem(title: "Rotate Right", style: .plain, target: nil, action: nil)
    }

    func imageEditingViewControllerRotateCounterClockwiseToolbarItem(
        _ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
            return UIBarButtonItem(title: "Rotate Left", style: .plain, target: nil, action: nil)
    }
}
