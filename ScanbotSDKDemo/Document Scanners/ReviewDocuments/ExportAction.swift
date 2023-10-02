//
//  ExportAction.swift
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 21.12.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class ExportAction {
    
    static func exportToPDF(_ storage: SBSDKIndexedImageStorage, completion: @escaping (Error?, URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            
            let config = SBSDKOpticalCharacterRecognizerConfiguration.ml()
            let options = SBSDKPDFRendererOptions(pageSize: .custom, pageOrientation: .auto, ocrConfiguration: config)
            
            SBSDKPDFRenderer(options: options).renderImageStorage(storage,
                                                                  indexSet: nil,
                                                                  output: url) { finished, error in 
                DispatchQueue.main.async {
                    completion(error, url)
                }
            }
        }
    }
    
    static func exportToTIFF(_ storage: SBSDKIndexedImageStorage, binarize: Bool, completion: @escaping (URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("tiff")
            
            let imageURLs = storage.imageURLs
            let params = binarize ? SBSDKTIFFImageWriterParameters.defaultParametersForBinaryImages()
            : SBSDKTIFFImageWriterParameters.default()
            
            let result = SBSDKTIFFImageWriter.writeTIFF(from: imageURLs, fileURL: url, parameters: params)
            DispatchQueue.main.async {
                completion(result == true ? url : nil)
            }
        }
    }
}
