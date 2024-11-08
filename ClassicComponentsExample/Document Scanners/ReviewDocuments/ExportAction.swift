//
//  ExportAction.swift
//  ClassicComponentsExample
//
//  Created by Sebastian Husche on 21.12.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class ExportAction {
    
    static func exportToPDF(_ document: SBSDKDocument, completion: @escaping (Error?, URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            
            
            let ocrConfiguration = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
            
            let attributes = SBSDKPDFAttributes(author: "Scanbot SDK Example App", 
                                                creator: "Scanbot SDK", 
                                                title: "Demo", 
                                                subject: "PDF Attributes", 
                                                keywords: "Scanbot,SDK,Demo,Example")
            
            let configuration = SBSDKPDFConfiguration(attributes: attributes, 
                                                      pageSize: .custom, 
                                                      pageDirection: .auto,
                                                      pageFit: .fitIn, 
                                                      dpi: 200, 
                                                      jpegQuality: 80,
                                                      resamplingMethod: .lanczos4)
            
            let _ = SBSDKPDFRenderer(configuration: configuration, 
                                     ocrConfiguration: ocrConfiguration,
                                     encrypter: nil).renderDocument(document, output: url) { finished, error in
                DispatchQueue.main.async {
                    completion(error, url)
                }
            }
        }
    }
    
    static func exportToTIFF(_ document: SBSDKDocument, binarize: Bool, completion: @escaping (URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("tiff")
            let params = binarize ? SBSDKTIFFWriterParameters.defaultParametersForBinaryImages
            : SBSDKTIFFWriterParameters.defaultParameters
            
            let writer = SBSDKTIFFWriter(parameters: params)
            
            Task {
                let result = await writer.writeTIFFAsync(document: document, toFile: url)
                DispatchQueue.main.async { 
                    completion(result) 
                }
            }
        }
    }
}
