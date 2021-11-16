//
//  AdjustableFiltersTableViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class AdjustableFiltersTableViewController: UIViewController {
    
    @IBOutlet private var filteredImageView: UIImageView?
    @IBOutlet private var processingIndicator: UIActivityIndicatorView?
    @IBOutlet private var tableView: UITableView?
    
    private let brightnessFilter = SBSDKBrightnessFilter()
    private let contrastFilter = SBSDKContrastFilter()
    private let saturationFilter = SBSDKSaturationFilter()
    private let vibranceFilter = SBSDKVibranceFilter()
    private let temperatureFilter = SBSDKTemperatureFilter()
    private let tintFilter = SBSDKTintAdjustFilter()
    private let whiteAndBlackPointFilter = SBSDKWhiteAndBlackPointFilter()
    private let shadowsHighlightsFilter = SBSDKShadowsHighlightsFilter()
    private let specialContrastFilter = SBSDKSpecialContrastFilter()
    
    private let smartFilter = SBSDKSmartFilter()
    
    private lazy var compoundFilter = {
        SBSDKCompoundFilter(filters: [brightnessFilter, contrastFilter, saturationFilter, vibranceFilter,
                                      temperatureFilter, tintFilter, specialContrastFilter, whiteAndBlackPointFilter,
                                      shadowsHighlightsFilter, smartFilter])
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
    
    @IBAction func cancelButtonDidPress(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
