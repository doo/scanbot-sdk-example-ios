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
    var filter: SBSDKParametricFilter?
    var counterClockwiseRotations: Int?
    
    init() {
        polygon = SBSDKPolygon()
        counterClockwiseRotations = 0
    }
    
    init(polygon: SBSDKPolygon?, filter: SBSDKParametricFilter?, counterClockwiseRotations: Int?) {
        self.polygon = polygon
        self.filter = filter
        self.counterClockwiseRotations = counterClockwiseRotations
    }
}

final class ImageManager {
    
    public static let shared = ImageManager()
    
    public let document = SBSDKScannedDocument()
    
    private init() {
        self.removeAllImages()
    }
    
    var numberOfImages: Int {
        return document.pages.count 
    }
    
    @discardableResult
    func add(image: SBSDKImageRef, polygon: SBSDKPolygon) -> Bool {
        return document.addPage(with: image, polygon: polygon, filters: []) != nil
    }
    
    func pageAt(index: Int) -> SBSDKScannedPage? {
        return document.page(at: index)
    }
    
    func originalImageAt(index: Int) -> SBSDKImageRef? {
        return document.page(at: index)?.originalImage
    }

    func originalImageURLAt(index: Int) -> URL? {
        return document.page(at: index)?.originalImageURI
    }

    func processedImageAt(index: Int) -> SBSDKImageRef? {
        return document.page(at: index)?.documentImage
    }
        
    func removeImageAt(index: Int) {
        if let page = document.page(at: index) {
            document.removePage(page)
        }
    }
    
    func removeAllImages() {
        document.removeAllPages()
    }
    
    func processImageAt(_ index: Int, withParameters parameters: ImageProcessingParameters) -> Bool {
        
        guard let page = document.page(at: index) else {
            return false
        }
        
        if let rotations = parameters.counterClockwiseRotations {
            page.rotation = SBSDKImageRotation.fromRotations(rotations)
        }
        if let polygon = parameters.polygon {
            page.polygon = polygon
        }
        if let filter = parameters.filter {
            page.filters = [filter]
        }
        return true
    }
}
