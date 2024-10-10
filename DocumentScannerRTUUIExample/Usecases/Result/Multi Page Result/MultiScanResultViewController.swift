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
            
            let numberOfPages = self?.document.pages.count ?? 0
            (0..<numberOfPages).forEach { index in
                self?.document.page(at: index)?.filters = [selectedFilter]
            }
            self?.collectionView.reloadData()
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
        let options = SBSDKPDFRendererOptions()
        
        // Create and set the OCR configuration for HOCR.
        options.ocrConfiguration = SBSDKOpticalCharacterRecognizerConfiguration.scanbotOCR()

        // Renders the document into a searchable PDF at the specified file url
        let renderer = SBSDKPDFRenderer(options: options)
        
        // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
        let progress = renderer.renderScannedDocument(document, output: pdfURL) { finished, error in
            
            if finished && error == nil {
                
                // Present the share screen
                self.share(url: pdfURL)
            }
        }
    }
    
    // Export to TIFF
    private func exportTIFF() {
        
        // Set the name and path for the TIFF file
        let name = "ScanbotSDK_TIFF_Example.tiff"
        let fileURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        // Get the cropped images of all the pages of the document
        let images = (0..<document.pages.count).compactMap { document.page(at: $0)?.documentImage }
        
        // Define export parameters for the TIFF
        // In this case using lowLightBinarization2 filter when exporting as TIFF
        // as an optimal setting
        let tiffExportParameters = SBSDKTIFFImageWriterParameters.defaultParametersForBinaryImages
        tiffExportParameters.dpi = 300
        tiffExportParameters.compression = .ccitt_t6
        tiffExportParameters.binarizationFilter = SBSDKLegacyFilter(legacyFilter: .lowLightBinarization2)
        
        // Use `SBSDKTIFFImageWriter` to write TIFF at the specified file url
        // and get the result
        let tiffWriter = SBSDKTIFFImageWriter(parameters: .defaultParameters, encrypter: nil)
        let success = tiffWriter.writeTIFF(with: images, toFile: fileURL)
        
        if success == true {
            
            // Present the share screen if file is successfully written
            share(url: fileURL)
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
        
        // Retrieve the document page
        let page = document.page(at: indexPath.row)
        
        // Check detection status
        if page?.documentDetectionStatus == .errorNothingDetected {
            
            // Use the full original image if nothing detected
            cell.resultImageView.image = page?.originalImage
            
        } else {
            
            // Use the cropped image otherwise
            cell.resultImageView.image = page?.documentImage
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
