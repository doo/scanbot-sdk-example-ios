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
        Filter.filters.forEach { filterType in
            let action = UIAlertAction(title: Filter.name(for: filterType), style: .default) { _ in
                let smartFilter = SBSDKSmartFilter()
                smartFilter.filterType = filterType
                let compoundFilter = SBSDKCompoundFilter(filters: [smartFilter])
                DispatchQueue(label: "FilterQueue").async { [weak self] in
                    guard let self = self,
                    let documentImageStorage = self.documentImageStorage,
                    let originalImageStorage = self.originalImageStorage else { return }
                    for index in 0..<documentImageStorage.imageCount {
                        if let filteredImage = compoundFilter.run(on: originalImageStorage.image(at: index)!) {
                            documentImageStorage.replaceImage(at: index, with: filteredImage)
                        }
                    }
                    DispatchQueue.main.async {
                        self.reloadData()
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
        [importButton, deleteAllButton, filterButton, exportButton]
            .forEach({ $0?.isEnabled = (documentImageStorage?.imageCount ?? 0) > 0 })
    }
        
    private func sharePDF(at url: URL) {
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = exportButton?.customView
        controller.popoverPresentationController?.sourceRect = exportButton?.customView?.bounds ?? .zero
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adjustableFiltersSegue" {
           if let navigationController = segue.destination as? UINavigationController,
              let controller = navigationController.viewControllers.first as? AdjustableFiltersTableViewController {
               navigationController.modalPresentationStyle = .fullScreen
               controller.selectedImage = documentImageStorage?.image(at: 0)
           }
       }
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
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

// MARK: - UIImagePickerControllerDelegate
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

// MARK: - SBSDKImageEditingViewControllerDelegate
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


struct Filter {
    static let filters: [SBSDKImageFilterType] = [
        SBSDKImageFilterTypeNone,
        SBSDKImageFilterTypeColor,
        SBSDKImageFilterTypeGray,
        SBSDKImageFilterTypePureGray,
        SBSDKImageFilterTypeBinarized,
        SBSDKImageFilterTypeColorDocument,
        SBSDKImageFilterTypePureBinarized,
        SBSDKImageFilterTypeBackgroundClean,
        SBSDKImageFilterTypeBlackAndWhite,
        SBSDKImageFilterTypeOtsuBinarization,
        SBSDKImageFilterTypeDeepBinarization,
        SBSDKImageFilterTypeEdgeHighlight,
        SBSDKImageFilterTypeLowLightBinarization,
        SBSDKImageFilterTypeLowLightBinarization2
    ]
    
    static func name(for filter: SBSDKImageFilterType) -> String {
        switch filter {
        case SBSDKImageFilterTypeNone:
            return "None"
        case SBSDKImageFilterTypeColor:
            return "Color"
        case SBSDKImageFilterTypeGray:
            return "Optimized greyscale"
        case SBSDKImageFilterTypePureGray:
            return "Pure greyscale"
        case SBSDKImageFilterTypeBinarized:
            return "Binarized"
        case SBSDKImageFilterTypeColorDocument:
            return "Color document"
        case SBSDKImageFilterTypePureBinarized:
            return "Pure binarized"
        case SBSDKImageFilterTypeBackgroundClean:
            return "Background clean"
        case SBSDKImageFilterTypeBlackAndWhite:
            return "Black & white"
        case SBSDKImageFilterTypeOtsuBinarization:
            return "Otsu binarization"
        case SBSDKImageFilterTypeDeepBinarization:
            return "Deep binarization"
        case SBSDKImageFilterTypeEdgeHighlight:
            return "Edge highlight"
        case SBSDKImageFilterTypeLowLightBinarization:
            return "Low light binarization"
        case SBSDKImageFilterTypeLowLightBinarization2:
            return "Low light binarization 2"
        default: return "UNKNOWN"
        }
    }
}

