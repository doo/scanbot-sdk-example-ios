//
//  ImageManager.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 10.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class ImageProcessingParameters {
    var polygon: SBSDKPolygon?
    var filter: SBSDKImageFilterType?
    var counterClockwiseRotations: Int?
    
    init() {
        polygon = SBSDKPolygon()
        filter = SBSDKImageFilterType.none
        counterClockwiseRotations = 0
    }
    
    init(polygon: SBSDKPolygon?, filter: SBSDKImageFilterType?, counterClockwiseRotations: Int?) {
        self.polygon = polygon
        self.filter = filter
        self.counterClockwiseRotations = counterClockwiseRotations
    }
}

final class ImageManager {
    
    public static let shared = ImageManager()
    
    public let document = SBSDKDocument()
    
    private init() {
        self.removeAllImages()
    }
    
    var numberOfImages: Int {
        return document.pages.count 
    }
    
    @discardableResult
    func add(image: UIImage, polygon: SBSDKPolygon) -> Bool {
        let page = SBSDKDocumentPage(image: image, polygon: polygon, filter: .none)
        return document.add(page)
    }
    
    func pageAt(index: Int) -> SBSDKDocumentPage? {
        return document.page(at: index)
    }
    
    func originalImageAt(index: Int) -> UIImage? {
        return document.page(at: index)?.originalImage
    }

    func originalImageURLAt(index: Int) -> URL? {
        return document.page(at: index)?.originalImageURL
    }

    func processedImageAt(index: Int) -> UIImage? {
        return document.page(at: index)?.documentImage
    }
        
    func removeImageAt(index: Int) {
        document.removePage(at: index)
    }
    
    func removeAllImages() {
        document.removeAllPages()
    }
    
    func processImageAt(_ index: Int, withParameters parameters: ImageProcessingParameters) -> Bool {
        
        guard let page = document.page(at: index) else {
            return false
        }
        
        if let rotations = parameters.counterClockwiseRotations {
            page.rotateClockwise(-rotations)
        }
        if let polygon = parameters.polygon {
            page.polygon = polygon
        }
        if let filter = parameters.filter {
            page.parametricFilters = [SBSDKLegacyFilter(filterType: filter.rawValue)]
        }
        return true
    }
}
