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
    private static var qualityCache = [URL: String]()

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
        importAction = ImportAction { [weak self] image in
            defer { self?.importAction = nil }
            guard let image = image else {
                return
            }
            DispatchQueue(label: "FilterQueue").async { [weak self] in
                do {
                    let result = try SBSDKDocumentScanner().run(image: image)
                    try ImageManager.shared.add(image: image, polygon: result.polygon ?? SBSDKPolygon())
                    DispatchQueue.main.async {
                        self?.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self?.sbsdk_showError(error) { [weak self] _ in
                            guard let self else { return }
                            self.sbsdk_forceClose(animated: true, completion: nil)
                        }
                    }
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
                        do {
                            try ImageManager.shared.processImageAt(index, withParameters: parameters)
                            DispatchQueue.main.async {
                                self?.reloadData()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self?.sbsdk_showError(error) { [weak self] _ in
                                    guard let self else { return }
                                    self.sbsdk_forceClose(animated: true, completion: nil)
                                }
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
        do {
            try ImageManager.shared.removeAllImages()
        } catch {
            sbsdk_showError(error)
        }
        reloadData()
    }
    
    @IBAction private func exportButtonTapped(_ item: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let exportPDF = UIAlertAction(title: "Export to PDF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToPDF(ImageManager.shared.document) { [weak self] (error, url) in
                self?.activityIndicator?.stopAnimating()
                if let error {
                    self?.sbsdk_showError(error) { [weak self] _ in
                        guard let self else { return }
                        self.sbsdk_forceClose(animated: true, completion: nil)
                    }
                    return
                } else if let url {
                    self?.sharePDF(at: url)
                }
            }
        }

        let exportBinarizedTIFF = UIAlertAction(title: "Export to Binarized TIFF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToTIFF(ImageManager.shared.document, binarize: true) { [weak self] error, url in
                self?.activityIndicator?.stopAnimating()
                if let error {
                    self?.sbsdk_showError(error) { [weak self] _ in
                        guard let self else { return }
                        self.sbsdk_forceClose(animated: true, completion: nil)
                    }
                    return
                } else if let url {
                    self?.shareTIFF(at: url)
                }
            }
        }

        let exportColorTIFF = UIAlertAction(title: "Export to Colored TIFF", style: .default) { [weak self] _ in
            self?.activityIndicator?.startAnimating()
            ExportAction.exportToTIFF(ImageManager.shared.document, binarize: false) { [weak self] error, url in
                self?.activityIndicator?.stopAnimating()
                if let error {
                    self?.sbsdk_showError(error) { [weak self] _ in
                        guard let self else { return }
                        self.sbsdk_forceClose(animated: true, completion: nil)
                    }
                    return
                } else if let url {
                    self?.shareTIFF(at: url)
                }
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
        DispatchQueue(label: "FilterQueue").sync { [weak self] in
            
            do {
                if let image = try ImageManager.shared.originalImageAt(index: item),
                   let url = try ImageManager.shared.originalImageURLAt(index: item) {
                    
                    let quality = try SBSDKDocumentQualityAnalyzer().run(image: image)
                    Self.qualityCache[url] = quality.quality?.stringValue ?? "No document"
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.showsQuality = false
                    self?.sbsdk_showError(error) { [weak self] _ in
                        guard let self else { return }
                        self.sbsdk_forceClose(animated: true, completion: nil)
                    }
                }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCollectionCell",
                                                  for: indexPath) as! ReviewDocumentsCollectionViewCell
        do {
            let image = try ImageManager.shared.processedImageAt(index: indexPath.item)
            cell.previewImageView?.image = try image?.toUIImage()
            
            if showsQuality {
                if let imageURL = try ImageManager.shared.originalImageURLAt(index: indexPath.item) {
                    if let quality = Self.qualityCache[imageURL] {
                        cell.infoLabelText = String(format: "Q: \(quality)")
                    } else {
                        cell.infoLabelText = "Calculating..."
                        calculateQualityFor(indexPath.item)
                    }
                }
            } else {
                cell.infoLabelText = nil
            }
        } catch {
            sbsdk_showError(error) { [weak self] _ in
                guard let self else { return }
                self.sbsdk_forceClose(animated: true, completion: nil)
            }
            showsQuality = false
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReviewDocumentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        do {
            let page = try ImageManager.shared.pageAt(index: indexPath.item)
            selectedImageIndex = indexPath.item
            let editingViewController = try SBSDKImageEditingViewController.create(image: page.originalImage!, polygon: page.polygon)
            editingViewController.delegate = self
            navigationController?.pushViewController(editingViewController, animated: true)
        } catch {
            sbsdk_showError(error) { [weak self] _ in
                guard let self else { return }
                self.sbsdk_forceClose(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - SBSDKImageEditingViewControllerDelegate
extension ReviewDocumentsViewController: SBSDKImageEditingViewControllerDelegate {
    func imageEditingViewController(_ editingViewController: SBSDKImageEditingViewController,
                                    didApplyChangesWith polygon: SBSDKPolygon,
                                    croppedImage: SBSDKImageRef) {
     
        guard let imageIndex = selectedImageIndex else { return }
        do {
            let page = try ImageManager.shared.pageAt(index: imageIndex)
            
            var rotations = editingViewController.rotations
            while rotations < 0 {
                rotations += 4
            }
            polygon.rotateCCW(UInt(rotations))
            
            page.polygon = polygon
            page.rotation = SBSDKImageRotation.fromRotations(editingViewController.rotations)
            
            self.reloadData()
            selectedImageIndex = nil
            editingViewController.navigationController?.popViewController(animated: true)
        } catch {
            sbsdk_showError(error) { [weak self] _ in
                guard let self else { return }
                self.sbsdk_forceClose(animated: true, completion: nil)
            }
        }
    }
    
    func imageEditingViewControllerDidFail(_ editingViewController: SBSDKImageEditingViewController, with error: any Error) {
        sbsdk_showError(error) { [weak self] _ in
            guard let self else { return }
            self.sbsdk_forceClose(animated: true, completion: nil)
        }
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
