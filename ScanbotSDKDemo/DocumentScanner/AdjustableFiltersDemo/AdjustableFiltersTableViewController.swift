//
//  AdjustableFiltersTableViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class SAdjustableFiltersTableViewController: UIViewController {
    
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
    
    private var selectedImage: UIImage?
    private var filteringQueue = DispatchQueue(label: "io.scanbotsdk.filtering")
    
    private var filterModels: [SFilterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildFilterModels()
        tableView?.reloadData()
    }
    
    private func buildFilterModels() {
        let brightness = SFilterModel(name: "Brightness") { [weak self] value in
            self?.brightnessFilter.brightness = value
            self?.updateImage()
        }
        let contrast = SFilterModel(name: "Contrast") { [weak self] value in
            self?.contrastFilter.contrast = value
            self?.updateImage()
        }
        let saturation = SFilterModel(name: "Saturation") { [weak self] value in
            self?.saturationFilter.saturation = value
            self?.updateImage()
        }
        let vibrance = SFilterModel(name: "Vibrance") { [weak self] value in
            self?.vibranceFilter.vibrance = value
            self?.updateImage()
        }
        let temperature = SFilterModel(name: "Temperature") { [weak self] value in
            self?.temperatureFilter.temperature = value
            self?.updateImage()
        }
        let tint = SFilterModel(name: "Tint") { [weak self] value in
            self?.tintFilter.tint = value
            self?.updateImage()
        }
        let blackPoint = SFilterModel(name: "Black Point") { [weak self] value in
            self?.whiteAndBlackPointFilter.blackPointOffset = value
            self?.updateImage()
        }
        let whitePoint = SFilterModel(name: "White Point") { [weak self] value in
            self?.whiteAndBlackPointFilter.whitePointOffset = value
            self?.updateImage()
        }
        let shadows = SFilterModel(name: "Shadows") { [weak self] value in
            self?.shadowsHighlightsFilter.shadows = value
            self?.updateImage()
        }
        let highlights = SFilterModel(name: "Highlights") { [weak self] value in
            self?.shadowsHighlightsFilter.highlights = value
            self?.updateImage()
        }
        let specialContrast = SFilterModel(name: "Special Contrast") { [weak self] value in
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
    private func updateImage() {
        
    }
}
