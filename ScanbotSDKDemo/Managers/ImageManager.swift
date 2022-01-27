//
//  ImageManager.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 10.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class ImageProcessingParameters {
    var polygon: SBSDKPolygon
    var filter: SBSDKImageFilterType
    var counterClockwiseRotations: Int
    
    init() {
        polygon = SBSDKPolygon()
        filter = SBSDKImageFilterTypeNone
        counterClockwiseRotations = 0
    }
    
    init(polygon: SBSDKPolygon, filter: SBSDKImageFilterType, counterClockwiseRotations: Int) {
        self.polygon = polygon
        self.filter = filter
        self.counterClockwiseRotations = counterClockwiseRotations
    }
}

final class ImageManager {
    
    public static let shared = ImageManager()
    
    public let processedImageStorage = storageForDirectory("/sbsdk-demo-processed-images")
    private let originalImageStorage = storageForDirectory("/sbsdk-demo-original-images")
    private var processingParameters = [URL : ImageProcessingParameters]()
    
    private init() {
        self.removeAllImages()
    }
    
    static private func storageForDirectory(_ directory: String) -> SBSDKIndexedImageStorage {
        let url = SBSDKStorageLocation.applicationDocumentsFolderURL().appendingPathComponent(directory)
        let location = SBSDKStorageLocation(baseURL: url)
        guard let storage = SBSDKIndexedImageStorage(storageLocation: location) else {
            fatalError("Failed to create the storage")
        }
        return storage
    }
    
    var numberOfImages: Int {
        return Int(originalImageStorage.imageCount)
    }
    
    @discardableResult
    func add(image: UIImage, polygon: SBSDKPolygon) -> Bool {
        if originalImageStorage.add(image) {
            let parameters = ImageProcessingParameters(polygon: polygon,
                                                       filter: SBSDKImageFilterTypeNone,
                                                       counterClockwiseRotations: 0)
            if processImageAt(Int(originalImageStorage.imageCount-1), withParameters: parameters) {
                return true
            } else {
                originalImageStorage.removeImage(at: originalImageStorage.imageCount - 1)
            }
        }
        return false
    }
    
    func originalImageAt(index: Int) -> UIImage? {
        if index < 0 || index >= numberOfImages { return nil }
        return originalImageStorage.image(at: UInt(index))
    }

    func originalImageURLAt(index: Int) -> URL? {
        if index < 0 || index >= numberOfImages { return nil }
        return originalImageStorage.imageURL(at: UInt(index))
    }

    func processedImageAt(index: Int) -> UIImage? {
        if index < 0 || index >= numberOfImages { return nil }
        return processedImageStorage.image(at: UInt(index))
    }
    
    func processingParametersAt(index: Int) -> ImageProcessingParameters? {
        guard let url = originalImageStorage.imageURL(at: UInt(index)) else {
            return nil
        }
        
        if let parameters = processingParameters[url] {
            return parameters
        } else {
            let parameters = ImageProcessingParameters()
            storeParameters(parameters, at: url)
            return parameters
        }
    }
    
    func storeParameters(_ parameters: ImageProcessingParameters, at url: URL) {
        processingParameters[url] = parameters
    }
    
    func removeImageAt(index: Int) {
        originalImageStorage.removeImage(at: UInt(index))
        processedImageStorage.removeImage(at: UInt(index))
        if let url = originalImageStorage.imageURL(at: UInt(index)) {
            processingParameters.removeValue(forKey: url)
        }
    }
    
    func removeAllImages() {
        originalImageStorage.removeAllImages()
        processedImageStorage.removeAllImages()
        processingParameters.removeAll()
    }
    
    func processImageAt(_ index: Int, withParameters parameters: ImageProcessingParameters) -> Bool {
        if index < 0 || index >= numberOfImages { return false }
        
        guard let image = originalImageStorage.image(at: UInt(index)) else {
            return false
        }
        
        guard let rotImage = image.sbsdk_imageRotatedCounterClockwise(parameters.counterClockwiseRotations) else {
            return false
        }
        
        guard let processedImage = rotImage.sbsdk_imageWarped(by: parameters.polygon,
                                                              andFilteredBy: parameters.filter,
                                                              imageScale: 1.0) else {
            return false
        }
        
        parameters.counterClockwiseRotations = 0
        originalImageStorage.replaceImage(at: UInt(index), with: rotImage)

        var success = true
        if index < processedImageStorage.imageCount {
            success = processedImageStorage.replaceImage(at: UInt(index), with: processedImage)
        } else {
            success = processedImageStorage.add(processedImage)
        }
        
        if !success {
            return false
        }
        
        guard let url = originalImageStorage.imageURL(at: UInt(index)) else {
            return false
        }
        storeParameters(parameters, at: url)
        return true
    }
}
