//
//  ReviewDocumentsViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 04.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class ReviewDocumentsViewController: UIViewController {
    

    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var importButton: UIBarButtonItem?
    @IBOutlet private var deleteAllButton: UIBarButtonItem?
    @IBOutlet private var filterButton: UIBarButtonItem?
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
    
    @IBAction private func filterButtonDidPress(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        FilterManager.filters.forEach { filterType in
            let action = UIAlertAction(title: FilterManager.name(for: filterType), style: .default) { _ in
                DispatchQueue(label: "FilterQueue").async { [weak self] in
                    for index in 0..<ImageManager.shared.numberOfImages {
                        let parameters = ImageManager.shared.processingParametersAt(index: index)!
                        parameters.filter = filterType
                        if ImageManager.shared.processImageAt(index, processingParameters: parameters) {
                            DispatchQueue.main.async {
                                self?.reloadData()
                            }
                        }
                    }
                }
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.bounds
        alert.popoverPresentationController?.permittedArrowDirections = []
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func deleteAllButtonDidPress(_ sender: Any) {
        ImageManager.shared.removeAllImages()
        reloadData()
    }
    
    @IBAction private func exportButtonDidPress(_ sender: Any) {
        activityIndicator?.startAnimating()
        DispatchQueue(label: "exportToPDF_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            do {
                let pdf = try SBSDKPDFRenderer.renderImageStorage(ImageManager.shared.processedImageStorage,
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
        [importButton, deleteAllButton, filterButton, exportButton]
            .forEach({ $0?.isEnabled = ImageManager.shared.numberOfImages > 0 })
    }
        
    private func sharePDF(at url: URL) {
        let controller = DemoPDFViewController.make(with: url)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adjustableFiltersSegue" {
           if let navigationController = segue.destination as? UINavigationController,
              let controller = navigationController.viewControllers.first as? AdjustableFiltersTableViewController {
               navigationController.modalPresentationStyle = .fullScreen
               controller.selectedImage = ImageManager.shared.processedImageStorage.image(at: 0)
           }
       }
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewDocumentsViewController: UICollectionViewDataSource {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.shared.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = ImageManager.shared.processedImageAt(index: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCollectionCell",
                                                      for: indexPath) as! ReviewDocumentsCollectionViewCell
        cell.previewImageView?.image = image
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReviewDocumentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = ImageManager.shared.originalImageAt(index: indexPath.item) else { return }

        selectedImageIndex = indexPath.item
        
        let editingViewController = SBSDKImageEditingViewController()
        editingViewController.delegate = self
        editingViewController.image = image
        
        navigationController?.pushViewController(editingViewController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ReviewDocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        DispatchQueue(label: "FilterQueue").async { [weak self] in
            let result = SBSDKDocumentDetector().detectDocumentPolygon(on: image,
                                                                       visibleImageRect: .zero,
                                                                       smoothingEnabled: false,
                                                                       useLiveDetectionParameters: false)

            ImageManager.shared.add(image: image, polygon: result.polygon ?? SBSDKPolygon())
            DispatchQueue.main.async {
                self?.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SBSDKImageEditingViewControllerDelegate
extension ReviewDocumentsViewController: SBSDKImageEditingViewControllerDelegate {
    func imageEditingViewController(_ editingViewController: SBSDKImageEditingViewController,
                                    didApplyChangesWith polygon: SBSDKPolygon,
                                    croppedImage: UIImage) {
     
        guard let selectedImageIndex = selectedImageIndex else { return }
        guard let parameters = ImageManager.shared.processingParametersAt(index: selectedImageIndex) else { return }
        parameters.polygon = polygon
        parameters.counterClockwiseRotations = -editingViewController.rotations
        DispatchQueue(label: "FilterQueue").async { [weak self] in
            if ImageManager.shared.processImageAt(selectedImageIndex, processingParameters: parameters) {
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }
        self.selectedImageIndex = nil
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
