//
//  MultiScanResultViewController.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 29.08.23.
//

import ScanbotSDK

final class MultiScanResultViewController: UIViewController {
    
    var document: SBSDKScannedDocument!
    
    @IBOutlet private var exportButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!
    
    // Apply Filter
    @IBAction private func filterButtonTapped(_ sender: UIButton) {
        let filterListViewController = FilterListViewController.make()
        
        // Filter selection callback handler
        filterListViewController.selectedFilter = { [weak self] selectedFilter in
            guard let self else { return }
            let numberOfPages = self.document.pages.count
            
            do {
                try (0..<numberOfPages).forEach { index in
                    try self.document.page(at: index).filters = [selectedFilter]
                }
                self.collectionView.reloadData()
            } catch {
                sbsdk_showError(error)
            }
        }
        
        navigationController?.present(filterListViewController, animated: true)
    }
    
    // Export
    @IBAction private func exportButtonTapped(_ sender: UIButton) {
        showExportDialogue(sender)
    }
}

extension MultiScanResultViewController {
    
    // Export to PDF
    private func exportPDF() {
        
        // Set the name and path for the pdf file
        let name = "ScanbotSDK_PDF_Example.pdf"
        let pdfURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        // Create the PDF rendering options object with default options.
        let configuration = SBSDKPDFConfiguration()
        
        // Create and set the OCR configuration for HOCR.
        let options = SBSDKOCREngineConfiguration.scanbotOCR()

        do {
            // Generate the document into a searchable PDF at the specified file url
            let generator = try SBSDKPDFGenerator(configuration: configuration,
                                                  ocrConfiguration: options,
                                                  useEncryptionIfAvailable: false)
            
            // Start the generation operation and store the SBSDKProgress to watch the progress or cancel the operation.
            let progress = generator.generate(from: document, output: pdfURL) { [weak self] finished, error in
                guard let self else { return }
                if finished && error == nil {
                    
                    // Present the share screen
                    self.share(url: pdfURL)
                } else if let sdkError = error as? SBSDKError, sdkError.isCanceled {
                    
                    // The operation was canceled. Handle if needed.
                    
                } else if let error {
                    
                    // An error occurred during the pdf generation. Show an error alert.
                    self.sbsdk_showError(error)
                }
            }
        } catch {
            
            // An error occurred during the pdf generation. Show an error alert.
            sbsdk_showError(error)
        }
    }
    
    // Export to TIFF
    private func exportTIFF() {
        
        // Set the name and path for the TIFF file
        let name = "ScanbotSDK_TIFF_Example.tiff"
        let fileURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        // Define the generation parameters for the TIFF
        // In this case using a custom binarization filter with a preset 4 when exporting as TIFF
        // as an optimal setting
        let tiffGeneratorParameters = SBSDKTIFFGeneratorParameters.defaultParametersForBinaryImages
        tiffGeneratorParameters.dpi = 300
        tiffGeneratorParameters.compression = .ccittT6
        let customFilter = SBSDKCustomBinarizationFilter()
        customFilter.preset = .preset4
        tiffGeneratorParameters.binarizationFilter = customFilter

        do {
            // Create and use `SBSDKTIFFGenerator` to write TIFF at the specified file url
            let tiffGenerator = try SBSDKTIFFGenerator(parameters: tiffGeneratorParameters, useEncryptionIfAvailable: false)
            try tiffGenerator.generate(from: document, to: fileURL)
            
            // Present the share screen if file is successfully written
            share(url: fileURL)
        } catch {
            sbsdk_showError(error)
        }
    }
}

extension MultiScanResultViewController {
    
    // To show export dialogue
    private func showExportDialogue(_ sourceButton: UIButton) {
        
        let alertController = UIAlertController(title: "Export Document",
                                                message: nil,
                                                preferredStyle: .alert)
        
        let pdfAction = UIAlertAction(title: "Export as PDF", style: .default) { _ in self.exportPDF() }
        let tiffAction = UIAlertAction(title: "Export as TIFF (1-bit)", style: .default) { _ in self.exportTIFF() }
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actions = [pdfAction, tiffAction, cancelActon]
        actions.forEach { alertController.addAction($0) }
        
        self.present(alertController, animated: true)
    }
    
    // To show activity (share) screen
    private func share(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = exportButton
        }
        present(activityViewController, animated: true)
    }
}

extension MultiScanResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return document.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiScanResultCollectionViewCell",
                                                      for: indexPath) as! MultiScanResultCollectionViewCell
        
        do {
            // Retrieve the document page
            let page = try document.page(at: indexPath.row)
        
            // Check detection status
            if page.documentDetectionStatus == .errorNothingDetected {
            
                // Use the full original image if nothing detected
                cell.resultImageView.image = try page.originalImage?.toUIImage()
                
            } else {
                
                // Use the cropped image otherwise
                cell.resultImageView.image = try page.documentImage?.toUIImage()
            }
        } catch {
            
            // An error occurred while retrieving the page or images.
            sbsdk_showError(error)
        }
        
        return cell
    }
}

extension MultiScanResultViewController {
    static func make(with document: SBSDKScannedDocument) -> MultiScanResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(identifier: "MultiScanResultViewController") as! MultiScanResultViewController
        resultViewController.document = document
        return resultViewController
    }
}
