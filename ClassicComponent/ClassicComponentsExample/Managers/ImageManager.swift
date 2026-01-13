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
    
    public let document: SBSDKScannedDocument
    
    private init() {
        do {
            document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
        } catch {
            fatalError("Failed to create SBSDKScannedDocument: \(error)")
        }
    }
    
    var numberOfImages: Int {
        return document.pages.count 
    }
    
    func add(image: SBSDKImageRef, polygon: SBSDKPolygon) throws {
        try document.addPage(with: image, polygon: polygon, filters: [])
    }
    
    func pageAt(index: Int) throws -> SBSDKScannedPage {
        return try document.page(at: index)
    }
    
    func originalImageAt(index: Int) throws -> SBSDKImageRef? {
        let page = try document.page(at: index)
        return page.originalImage
    }

    func originalImageURLAt(index: Int) throws -> URL? {
        let page = try document.page(at: index)
        return page.originalImageURI
    }

    func processedImageAt(index: Int) throws -> SBSDKImageRef? {
        let page = try document.page(at: index)
        return page.documentImage
    }
        
    func removeImageAt(index: Int) throws {
        let page = try document.page(at: index)
        try document.removePage(page)
    }
    
    func removeAllImages() throws {
        try document.removeAllPages()
    }
    
    func processImageAt(_ index: Int, withParameters parameters: ImageProcessingParameters) throws {
        
        let page = try document.page(at: index)
        
        let rotations = parameters.counterClockwiseRotations ?? 0
        let polygon = parameters.polygon
        let filters = parameters.filter != nil ? [parameters.filter!] : nil
        
        try page.apply(rotation: SBSDKImageRotation.fromRotations(rotations), polygon: polygon, filters: filters)
    }
}
