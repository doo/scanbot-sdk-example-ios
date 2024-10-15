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
            
            
            let config = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()
            
            let attributes = SBSDKPDFAttributes(author: "Scanbot SDK Example App", 
                                                creator: "Scanbot SDK", 
                                                title: "Demo", 
                                                subject: "PDF Attributes", 
                                                keywords: ["Scanbot", "SDK", "Demo", "Example"])
            
            
            let options = SBSDKPDFRendererOptions(pageSize: .custom,
                                                  pageFitMode: .fitIn,
                                                  pageOrientation: .auto,
                                                  dpi: 200,
                                                  resample: true,
                                                  jpegQuality: 80,
                                                  ocrConfiguration: config,
                                                  pdfAttributes: attributes)
            
            let _ = SBSDKPDFRenderer(options: options).renderDocument(document, output: url) { finished, error in
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
            
            let params = binarize ? SBSDKTIFFImageWriterParameters.defaultParametersForBinaryImages
            : SBSDKTIFFImageWriterParameters.defaultParameters
            
            let writer = SBSDKTIFFImageWriter(parameters: params)
            
            Task {
                let result = await writer.writeTIFFAsync(document: document, toFile: url)
                DispatchQueue.main.async { 
                    completion(result) 
                }
            }
        }
    }
}
