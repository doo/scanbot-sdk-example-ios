//
//  UsecaseExportImage.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 13.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseExportImage: Usecase {
    private let document: SBSDKUIDocument
    private let processingHandler: (()->())
    private let completionHandler: ((Error?, URL?)->())
    private var barButtonItem: UIBarButtonItem?
    
    init(document: SBSDKUIDocument,
         barButtonItem: UIBarButtonItem?,
         processingHandler: @escaping (()->()),
         completionHandler: @escaping ((Error?, URL?)->())) {
        self.document = document
        self.processingHandler = processingHandler
        self.completionHandler = completionHandler
        self.barButtonItem = barButtonItem
        
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        showExportAlert(from: barButtonItem)
    }
    
    private func showExportAlert(from barButtonItem: UIBarButtonItem?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.barButtonItem = barButtonItem
        let exportPDF = UIAlertAction(title: "Export to PDF", style: .default) { [weak self] _ in
            self?.processingHandler()
            self?.exportToPDF() { [weak self] (error, url) in
                self?.completionHandler(error, url)
            }
        }
        
        let exportBinarizedTIFF = UIAlertAction(title: "Export to Binarized TIFF", style: .default) { [weak self] _ in
            self?.processingHandler()
            self?.exportToTIFF(binarize: true) { [weak self] url in
                self?.completionHandler(nil, url)
            }
        }
        
        let exportColorTIFF = UIAlertAction(title: "Export to Colored TIFF", style: .default) { [weak self] _ in
            self?.processingHandler()
            self?.exportToTIFF(binarize: false) { [weak self] url in
                self?.completionHandler(nil, url)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(exportPDF)
        alert.addAction(exportBinarizedTIFF)
        alert.addAction(exportColorTIFF)
        alert.addAction(cancel)
        alert.popoverPresentationController?.permittedArrowDirections = [.any]
        presenter?.present(alert, animated: true, completion: nil)
    }
    
    func exportToPDF(completion: @escaping (Error?, URL?) -> ()) {
        DispatchQueue(label: "export_queue").async {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("pdf")
            let config = SBSDKOpticalCharacterRecognizerConfiguration.ml()
            let options = SBSDKPDFRendererOptions(pageSize: .custom, pageOrientation: .auto, ocrConfiguration: config)
            let error = SBSDKUIPDFRenderer.renderDocument(self.document,
                                                          with: options,
                                                          output: url)
            DispatchQueue.main.async {
                completion(error, url)
            }
        }
    }
    
    func exportToTIFF(binarize: Bool, completion: @escaping (URL?) -> ()) {
        DispatchQueue(label: "export_queue").async { [weak self] in
            guard let self = self else { return }
            
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("document")
                .appendingPathExtension("tiff")
            
            var images: [UIImage] = []
            for i in 0..<self.document.numberOfPages() {
                if let page = self.document.page(at: i), let url = page.documentImage() {
                    images.append(url)
                }
            }
            let params = binarize ? SBSDKTIFFImageWriterParameters.defaultParametersForBinaryImages()
            : SBSDKTIFFImageWriterParameters.default()
            
            let result = SBSDKTIFFImageWriter.writeTIFF(images, fileURL: url, parameters: params)

            DispatchQueue.main.async {
                completion(result == true ? url : nil)
            }
        }
    }
}
