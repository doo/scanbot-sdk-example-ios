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
    
    static func exportToPDF(_ document: SBSDKScannedDocument, completion: @escaping (Error?, URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            
            
            let ocrConfiguration = SBSDKOCREngineConfiguration.scanbotOCR()
            
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
            
            Task {
                do {
                    let generator = try SBSDKPDFGenerator(configuration: configuration,
                                                          ocrConfiguration: ocrConfiguration,
                                                          useEncryptionIfAvailable: false)
                    
                    let result = try await generator.generate(from: document, output: url)
                    DispatchQueue.main.async { completion(nil, result) }
                } catch {
                    DispatchQueue.main.async { completion(error, nil) }
                }
            }
        }
    }
    
    static func exportToTIFF(_ document: SBSDKScannedDocument, binarize: Bool, completion: @escaping (Error?, URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("tiff")
            let params = binarize ? SBSDKTIFFGeneratorParameters.defaultParametersForBinaryImages
            : SBSDKTIFFGeneratorParameters.defaultParameters
            
            
            Task {
                do {
                    let generator = try SBSDKTIFFGenerator(parameters: params, useEncryptionIfAvailable: false)
                    let result = try await generator.generate(from: document, to: url)
                    DispatchQueue.main.async {
                        completion(nil, result)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(error, nil)
                    }
                }
            }
        }
    }
}
