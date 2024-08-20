//
//  SingleScanResultViewController.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class SingleScanResultViewController: UIViewController {
    
    @IBOutlet private var documentQualityLabel: UILabel!
    @IBOutlet private var singlePageImageView: UIImageView!
    @IBOutlet private var exportButton: UIButton!
    
    var document: SBSDKDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = document.page(at: 0)
        
        // Check detection status
        if page?.status == .error_NothingDetected {
            
            // Use the full original image if nothing detected
            singlePageImageView.image = document.page(at: 0)?.originalImage
            
        } else {
            
            // Use the cropped image otherwise
            singlePageImageView.image = document.page(at: 0)?.documentImage
        }
    }
    
    // Apply Filter
    @IBAction private func filterButtonTapped(_ sender: UIButton) {
        
        let filterListViewController = FilterListViewController.make()
        
        // Filter selection callback handler
        filterListViewController.selectedFilter = { [weak self] selectedFilter in
            
            self?.document.page(at: 0)?.parametricFilters = [selectedFilter]
            self?.singlePageImageView.image = self?.document.page(at: 0)?.documentImage
        }
        
        self.present(filterListViewController, animated: true)
    }
    
    // Manual Cropping
    @IBAction private func manualCropButtonTapped(_ sender: UIButton) {
        
        // Get the page
        guard let page = document.page(at: 0) else { return }
        
        // Initialize the cropping screen configuration object using default configurations
        let configuration = SBSDKUICroppingScreenConfiguration.defaultConfiguration
        
        // Set colors
        configuration.uiConfiguration.topBarBackgroundColor = .appAccentColor
        configuration.uiConfiguration.topBarButtonsColor = .white
        configuration.uiConfiguration.bottomBarBackgroundColor = .appAccentColor
        configuration.uiConfiguration.bottomBarButtonsColor = .white
        
        // Present the cropping view controller
        SBSDKUICroppingViewController.present(on: self,
                                              page: page,
                                              configuration: configuration,
                                              delegate: self)
    }
    
    // Document Quality analysis
    @IBAction private func analyzeDocumentQualityButtonTapped(_ sender: UIButton) {
        
        // Get the cropped image
        guard let documentPageImage = document.page(at: 0)?.documentImage else { return }
        
        // Initialize document quality analyzer
        let documentAnalyzer = SBSDKDocumentQualityAnalyzer()
        
        // Get the document quality analysis result by passing the image to the analyzer
        let documentQuality = documentAnalyzer.analyze(on: documentPageImage)
        
        documentQualityLabel.text = "Document Quality: \(map(documentQuality))"
    }
    
    // Map document quality analysis result into string
    private func map(_ documentQuality: SBSDKDocumentQuality) -> String {
        switch documentQuality {
        case .noDocument:
            return "No Document"
        case .veryPoor:
            return "Very Poor"
        case .poor:
            return "Poor"
        case .reasonable:
            return "Reasonable"
        case .good:
            return "Good"
        case .excellent:
            return "Excelent"
        @unknown default:
            return ""
        }
    }
    
    // Export
    @IBAction private func exportButtonTapped(_ sender: UIButton) {
        showExportDialogue(sender)
    }
    
    // Export to PNG
    private func exportPNG() {
        
        // Set the name and path for the png file
        let name = "ScanbotSDK_PNG_Example.png"
        let pngURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        guard let pngData = document.page(at: 0)?.documentImage?.pngData() else { return }
        
        do {
            try pngData.write(to: pngURL)
        }
        catch {
            print(error)
        }
        
        // Present the share screen
        share(url: pngURL)
    }
    
    // Export to JPG
    private func exportJPG() {
        
        // Set the name and path for the jpg file
        let name = "ScanbotSDK_JPG_Example.jpg"
        let jpgURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        guard let jpgData = document.page(at: 0)?.documentImage?.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try jpgData.write(to: jpgURL)
        }
        catch {
            print(error)
        }
        
        // Present the share screen
        share(url: jpgURL)
    }
    
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
        let progress = renderer.renderDocument(document, output: pdfURL) { finished, error in
            
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

// Delegate protocol for `SBSDKUICroppingViewController`
extension SingleScanResultViewController: SBSDKUICroppingViewControllerDelegate {
    
    // Informs the delegate that the polygon or orientation of the edited page was changed
    // and the cropping view controller did dismiss
    func croppingViewController(_ viewController: SBSDKUICroppingViewController,
                                didFinish changedPage: SBSDKDocumentPage) {
        
        self.document.removePage(at: 0)
        self.document.insert(changedPage, at: 0)
        self.singlePageImageView.image = changedPage.documentImage
    }
}

extension SingleScanResultViewController {
    
    // To show export dialogue
    private func showExportDialogue(_ sourceButton: UIButton) {
        
        let alertController = UIAlertController(title: "Export Document",
                                                message: nil,
                                                preferredStyle: .alert)
        
        let jpgAction = UIAlertAction(title: "Export as JPG", style: .default) { _ in self.exportJPG() }
        let pngAction = UIAlertAction(title: "Export as PNG", style: .default) { _ in self.exportPNG() }
        let pdfAction = UIAlertAction(title: "Export as PDF", style: .default) { _ in self.exportPDF() }
        let tiffAction = UIAlertAction(title: "Export as TIFF (1-bit)", style: .default) { _ in self.exportTIFF() }
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actions = [jpgAction, pngAction, pdfAction, tiffAction, cancelActon]
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

extension SingleScanResultViewController {
    static func make(with document: SBSDKDocument) -> SingleScanResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "SingleScanResultViewController")
        as! SingleScanResultViewController
        resultViewController.document = document
        return resultViewController
    }
}
