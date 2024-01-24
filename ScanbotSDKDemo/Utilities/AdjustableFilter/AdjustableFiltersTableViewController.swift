//
//  AdjustableFiltersTableViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class AdjustableFiltersTableViewController: UIViewController {
    
    @IBOutlet private var filteredImageView: UIImageView?
    @IBOutlet private var processingIndicator: UIActivityIndicatorView?
    @IBOutlet private var tableView: UITableView?
    
    private let brightnessFilter = SBSDKBrightnessFilter(brightness: 0.0)
    private let contrastFilter = SBSDKContrastFilter(contrast: 0.0)
    private let saturationFilter = SBSDKSaturationFilter(saturation: 0.0)
    private let vibranceFilter = SBSDKVibranceFilter(vibrance: 0.0)
    private let temperatureFilter = SBSDKTemperatureFilter(temperature: 0.0)
    private let tintFilter = SBSDKTintAdjustFilter(tint: 0.0)
    private let whiteAndBlackPointFilter = SBSDKWhiteAndBlackPointFilter(whitePointOffset: 0.0, blackPointOffset: 0.0)
    private let shadowsHighlightsFilter = SBSDKShadowsHighlightsFilter(highlights: 0.0, shadows: 0.0)
    private let specialContrastFilter = SBSDKSpecialContrastFilter(amount: 0.0)
    
    private lazy var compoundFilter = {
        SBSDKCompoundFilter(filters: [brightnessFilter, contrastFilter, saturationFilter, vibranceFilter,
                                      temperatureFilter, tintFilter, specialContrastFilter, whiteAndBlackPointFilter,
                                      shadowsHighlightsFilter])
    }()
    
    var selectedImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    private var filteringQueue = DispatchQueue(label: "io.scanbotsdk.filtering")
    
    private var filterModels: [AdjustableFilterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildFilterModels()
        tableView?.reloadData()
    }
    
    private func buildFilterModels() {
        let brightness = AdjustableFilterModel(name: "Brightness") { [weak self] value in
            self?.brightnessFilter.brightness = value
            self?.updateImage()
        }
        let contrast = AdjustableFilterModel(name: "Contrast") { [weak self] value in
            self?.contrastFilter.contrast = value
            self?.updateImage()
        }
        let saturation = AdjustableFilterModel(name: "Saturation") { [weak self] value in
            self?.saturationFilter.saturation = value
            self?.updateImage()
        }
        let vibrance = AdjustableFilterModel(name: "Vibrance") { [weak self] value in
            self?.vibranceFilter.vibrance = value
            self?.updateImage()
        }
        let temperature = AdjustableFilterModel(name: "Temperature") { [weak self] value in
            self?.temperatureFilter.temperature = value
            self?.updateImage()
        }
        let tint = AdjustableFilterModel(name: "Tint") { [weak self] value in
            self?.tintFilter.tint = value
            self?.updateImage()
        }
        let blackPoint = AdjustableFilterModel(name: "Black Point") { [weak self] value in
            self?.whiteAndBlackPointFilter.blackPointOffset = value
            self?.updateImage()
        }
        let whitePoint = AdjustableFilterModel(name: "White Point") { [weak self] value in
            self?.whiteAndBlackPointFilter.whitePointOffset = value
            self?.updateImage()
        }
        let shadows = AdjustableFilterModel(name: "Shadows") { [weak self] value in
            self?.shadowsHighlightsFilter.shadows = value
            self?.updateImage()
        }
        let highlights = AdjustableFilterModel(name: "Highlights") { [weak self] value in
            self?.shadowsHighlightsFilter.highlights = value
            self?.updateImage()
        }
        let specialContrast = AdjustableFilterModel(name: "Special Contrast") { [weak self] value in
            self?.specialContrastFilter.amount = value
            self?.updateImage()
        }
        filterModels.append(brightness)
        filterModels.append(contrast)
        filterModels.append(saturation)
        filterModels.append(vibrance)
        filterModels.append(temperature)
        filterModels.append(tint)
        filterModels.append(blackPoint)
        filterModels.append(whitePoint)
        filterModels.append(shadows)
        filterModels.append(highlights)
        filterModels.append(specialContrast)
    }
    
    @objc private func applyFilterChain() {
        filteringQueue.async { [weak self] in
            DispatchQueue.main.sync { [weak self] in
                self?.processingIndicator?.startAnimating()
            }
            guard let selectedImage = self?.selectedImage else { return }
            let filteredImage = self?.compoundFilter.run(on: selectedImage)
            DispatchQueue.main.sync {
                self?.filteredImageView?.image = filteredImage
                self?.processingIndicator?.stopAnimating()
            }
        }
    }
    
    @IBAction func importButtonDidPress(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    private func updateImage() {
        if selectedImage == nil { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(applyFilterChain), object: nil)
        perform(#selector(applyFilterChain), with: nil, afterDelay: 0.2)
    }
}

extension AdjustableFiltersTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! AdjustableFilterTableViewCell
        cell.filterModel = filterModels[indexPath.row]
        return cell
    }
}

extension AdjustableFiltersTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.originalImage] as? UIImage
        dismiss(animated: true) { [weak self] in
            self?.updateImage()
        }
    }
}
