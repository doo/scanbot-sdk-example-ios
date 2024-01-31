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
            
            let config = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
            let options = SBSDKPDFRendererOptions(pageSize: .custom,
                                                  pageFitMode: .fitIn,
                                                  pageOrientation: .auto,
                                                  dpi: 200,
                                                  resample: true,
                                                  jpegQuality: 80,
                                                  ocrConfiguration: config)
            
            let _ = SBSDKPDFRenderer(options: options).renderImageStorage(storage,
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
            let params = binarize ? SBSDKTIFFImageWriterParameters.defaultParametersForBinaryImages
            : SBSDKTIFFImageWriterParameters.defaultParameters
            
            let writer = SBSDKTIFFImageWriter(parameters: params)
            
            let result = writer.writeTIFF(from: imageURLs, toFile: url)
            DispatchQueue.main.async {
                completion(result == true ? url : nil)
            }
        }
    }
}
