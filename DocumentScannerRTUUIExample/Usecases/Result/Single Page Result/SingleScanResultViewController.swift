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
    
    var document: SBSDKScannedDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let page = document.page(at: 0)
        
        // Check detection status
        if page?.documentDetectionStatus == .errorNothingDetected {
            
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
            
            self?.document.page(at: 0)?.filters = [selectedFilter]
            self?.singlePageImageView.image = self?.document.page(at: 0)?.documentImage
        }
        
        self.present(filterListViewController, animated: true)
    }
    
    // Manual Cropping
    @IBAction private func manualCropButtonTapped(_ sender: UIButton) {
        
        // Get the page
        guard let page = document.page(at: 0) else { return }
        
        // Initialize the cropping configuration object using document and page uuids
        let configuration = SBSDKUI2CroppingConfiguration(documentUuid: document.uuid,
                                                          pageUuid: page.uuid)
        
        // Set the colors
        // e.g
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: .appAccentColor)
        configuration.palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: .white)
        
        // Configure the screen
        // e.g
        configuration.cropping.topBarTitle.text = "Cropping Screen"
        configuration.cropping.bottomBar.resetButton.visible = true
        configuration.cropping.bottomBar.rotateButton.visible = true
        configuration.cropping.bottomBar.detectButton.visible = true
        
        // Present the cropping view controller
        SBSDKUI2CroppingViewController.present(on: self,
                                               configuration: configuration) { croppingResult in
            
            // Completion handler to process the result.
            if let croppingResult {
                
                if let error = croppingResult.errorMessage {
                    // There was an error.
                    print(error)
                    
                } else {
                    
                    // The screen is dismissed without errors.
                    
                    self.singlePageImageView.image = page.documentImage
                }
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
    
    // Document Quality analysis
    @IBAction private func analyzeDocumentQualityButtonTapped(_ sender: UIButton) {
        
        // Get the cropped image
        guard let documentPageImage = document.page(at: 0)?.documentImage else { return }
        
        // Initialize document quality analyzer
        let documentAnalyzer = SBSDKDocumentQualityAnalyzer()
        
        // Get the document quality analysis result by passing the image to the analyzer
        let documentQualityResult = documentAnalyzer.analyze(on: documentPageImage)
        
        let documentQuality = map(documentQualityResult?.quality)
        documentQualityLabel.text = "Document Quality: \(documentQuality)"
    }
    
    // Map document quality analysis result into string
    private func map(_ documentQuality: SBSDKDocumentQuality?) -> String {
        switch documentQuality {
        case .veryPoor:
            return "Very Poor"
        case .poor:
            return "Poor"
        case .reasonable:
            return "Reasonable"
        case .good:
            return "Good"
        case .excellent:
            return "Excellent"
        default:
            return "No Document"
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
        let configuration = SBSDKPDFConfiguration()
        
        // Create and set the OCR configuration for HOCR.
        let options = SBSDKOCREngineConfiguration.scanbotOCR()

        // Renders the document into a searchable PDF at the specified file url
        let generator = SBSDKPDFGenerator(configuration: configuration, ocrConfiguration: options)
        
        // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
        let progress = generator.generate(from: document, output: pdfURL) { finished, error in
            
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
        
        // Define the generation parameters for the TIFF
        // In this case using lowLightBinarization2 filter when generating as TIFF
        // as an optimal setting
        let tiffGeneratorParameters = SBSDKTIFFGeneratorParameters.defaultParametersForBinaryImages
        tiffGeneratorParameters.dpi = 300
        tiffGeneratorParameters.compression = .ccittT6
        tiffGeneratorParameters.binarizationFilter = SBSDKLegacyFilter(legacyFilter: .lowLightBinarization2)
        
        // Use `SBSDKTIFFGenerator` to write TIFF at the specified file url
        // and get the result
        let tiffGenerator = SBSDKTIFFGenerator(parameters: tiffGeneratorParameters, encrypter: nil)
        let success = tiffGenerator.generate(from: images, to: fileURL)
        
        if success == true {
            
            // Present the share screen if file is successfully written
            share(url: fileURL)
        }
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
    static func make(with document: SBSDKScannedDocument) -> SingleScanResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultViewController = storyboard.instantiateViewController(withIdentifier: "SingleScanResultViewController")
        as! SingleScanResultViewController
        resultViewController.document = document
        return resultViewController
    }
}
