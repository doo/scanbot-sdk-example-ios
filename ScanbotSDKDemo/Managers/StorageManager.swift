//
//  StorageManager.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 10.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class ImageStorageManager {
    
    static let shared = ImageStorageManager()
    
    let documentImageStorage = storageForDirectory("/sbsdk-demo-document-images")
    let originalImageStorage = storageForDirectory("/sbsdk-demo-original-images")
    
    static private func storageForDirectory(_ directory: String) -> SBSDKIndexedImageStorage {
        guard let appDocumentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                      in: .userDomainMask).last else {
            fatalError("Failed to fetch document's directory URL")
        }
        let imagesDirectory = appDocumentsDirectory.path + directory
        let imagesDirectoryUrl = URL(fileURLWithPath: imagesDirectory, isDirectory: true)
        let storageLocation = SBSDKStorageLocation(baseURL: imagesDirectoryUrl)
        guard let storage = SBSDKIndexedImageStorage(storageLocation: storageLocation) else {
            fatalError("Failed to create the storage")
        }
        return storage
    }
}
