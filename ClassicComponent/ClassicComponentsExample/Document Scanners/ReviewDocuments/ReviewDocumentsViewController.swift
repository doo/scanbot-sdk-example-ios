//
//  ReviewDocumentsViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 04.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class ReviewDocumentsViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var importButton: UIBarButtonItem?
    @IBOutlet private var clearButton: UIBarButtonItem?
    @IBOutlet private var filterButton: UIBarButtonItem?
    @IBOutlet private var exportButton: UIBarButtonItem?
    @IBOutlet private var qualityButton: UIBarButtonItem!
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?

    private var selectedImageIndex: Int?
    private var importAction: ImportAction?
    private static var showsQuality: Bool = false
    private static var qualityCache = [URL: SBSDKDocumentQuality]()

    private var showsQuality: Bool = showsQuality {
        didSet {
            Self.showsQuality = showsQuality
            if isViewLoaded { reloadData() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        toolbar?.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @IBAction private func importButtonTapped(_ item: UIBarButtonItem) {
        importAction = ImportAction { image in
            guard let image = image else { return }
            DispatchQueue(label: "FilterQueue").async { [weak self] in
                let result = SBSDKDocumentScanner().scan(from: image)

                ImageManager.shared.add(image: image, polygon: result?.polygon ?? SBSDKPolygon())
                DispatchQueue.main.async {
                    self?.reloadData()
                }
            }
        }
        importAction?.showImagePicker(on: self)
    }
    
    @IBAction private func filterButtonTapped(_ item: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        FilterManager.filters.forEach { filterType in
            let action = UIAlertAction(title: FilterManager.name(for: filterType), style: .default) { _ in
                DispatchQueue(label: "FilterQueue").async { [weak self] in
                    for index in 0..<ImageManager.shared.numberOfImages {
                        let parameters = ImageProcessingParameters(polygon: nil, filter: filterType, counterClockwiseRotations: nil)
                        if ImageManager.shared.processImageAt(index, withParameters: parameters) {
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
        alert.popoverPresentationController?.barButtonItem = item
        alert.popoverPresentationController?.permittedArrowDirections = [.any]
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func clearButtonTapped(_ item: UIBarButtonItem) {
        ImageManager.shared.removeAllImages()
        reloadData()
    }
    
    @IBAction private func exportButtonTapped(_ item: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let exportPDF = UIAlertAction(title: "Export to PDF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToPDF(ImageManager.shared.document) { [weak self] (error, url) in
                self?.activityIndicator?.stopAnimating()
                guard let url = url else {
                    print("Failed to render PDF. Description: \(error?.localizedDescription ?? "")")
                    return
                }
                self?.sharePDF(at: url)
            }
        }

        let exportBinarizedTIFF = UIAlertAction(title: "Export to Binarized TIFF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToTIFF(ImageManager.shared.document, binarize: true) { [weak self] url in
                self?.activityIndicator?.stopAnimating()
                guard let url = url else {
                    print("Failed to render TIFF.")
                    return
                }
                self?.shareTIFF(at: url)
            }
        }

        let exportColorTIFF = UIAlertAction(title: "Export to Colored TIFF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToTIFF(ImageManager.shared.document, binarize: false) { [weak self] url in
                self?.activityIndicator?.stopAnimating()
                guard let url = url else {
                    print("Failed to render TIFF.")
                    return
                }
                self?.shareTIFF(at: url)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(exportPDF)
        alert.addAction(exportBinarizedTIFF)
        alert.addAction(exportColorTIFF)
        alert.addAction(cancel)
        alert.popoverPresentationController?.barButtonItem = item
        alert.popoverPresentationController?.permittedArrowDirections = [.any]
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func qualityButtonTapped(_ item: UIBarButtonItem) {
        showsQuality = !showsQuality
    }
    
    private func reloadData() {
        collectionView?.reloadData()
        [clearButton, filterButton, exportButton, qualityButton]
            .forEach({ $0?.isEnabled = ImageManager.shared.numberOfImages > 0 })
    }
        
    private func sharePDF(at url: URL) {
        let controller = DemoPDFViewController.make(with: url)
        navigationController?.pushViewController(controller, animated: true)
    }

    private func shareTIFF(at url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func calculateQualityFor(_ item: Int) {
        DispatchQueue(label: "FilterQueue").async { [weak self] in
            if let image = ImageManager.shared.originalImageAt(index: item),
                let url = ImageManager.shared.originalImageURLAt(index: item) {
                let quality = SBSDKDocumentQualityAnalyzer().analyze(on: image)
                Self.qualityCache[url] = quality?.quality
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadItems(at: [IndexPath(item: item, section: 0)])
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
        
        if showsQuality {
            if let imageURL = ImageManager.shared.originalImageURLAt(index: indexPath.item) {
                if let quality = Self.qualityCache[imageURL] {
                    cell.infoLabelText = String(format: "Q: \(quality.stringValue)")
                } else {
                    cell.infoLabelText = "Calculating..."
                    calculateQualityFor(indexPath.item)
                }
            }
        } else {
            cell.infoLabelText = nil
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReviewDocumentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let page = ImageManager.shared.pageAt(index: indexPath.item) else {
            return
        }

        selectedImageIndex = indexPath.item
        
        let editingViewController = SBSDKImageEditingViewController.create(page: page)
        editingViewController.delegate = self
        navigationController?.pushViewController(editingViewController, animated: true)
    }
}

// MARK: - SBSDKImageEditingViewControllerDelegate
extension ReviewDocumentsViewController: SBSDKImageEditingViewControllerDelegate {
    func imageEditingViewController(_ editingViewController: SBSDKImageEditingViewController,
                                    didApplyChangesWith polygon: SBSDKPolygon,
                                    croppedImage: UIImage) {
     
        guard let imageIndex = selectedImageIndex else { return }
        guard let page = ImageManager.shared.pageAt(index: imageIndex) else { return }
        
        var rotations = editingViewController.rotations
        while rotations < 0 {
            rotations += 4
        }
        polygon.rotateCCW(UInt(rotations))
        
        page.polygon = polygon
        page.rotateClockwise(editingViewController.rotations)
        
        self.reloadData()
        selectedImageIndex = nil
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
