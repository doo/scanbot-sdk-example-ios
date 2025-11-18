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
        
        do {
            let page = try document.page(at: 0)
            
            // Check detection status
            if page.documentDetectionStatus == .errorNothingDetected {
                
                // Use the full original image if nothing detected
                singlePageImageView.image = try document.page(at: 0).originalImage?.toUIImage()
                
            } else {
                
                // Use the cropped image otherwise
                singlePageImageView.image = try document.page(at: 0).documentImage?.toUIImage()
            }
        } catch {
            // An error occurred. Show an error alert.
            sbsdk_showError(error)
        }
    }
    
    // Apply Filter
    @IBAction private func filterButtonTapped(_ sender: UIButton) {
        
        let filterListViewController = FilterListViewController.make()
        
        // Filter selection callback handler
        filterListViewController.selectedFilter = { [weak self] selectedFilter in
            guard let self else { return }
            do {
                try self.document.page(at: 0).filters = [selectedFilter]
                self.singlePageImageView.image = try self.document.page(at: 0).documentImage?.toUIImage()
            } catch {
                self.sbsdk_showError(error)
            }
        }
        self.present(filterListViewController, animated: true)
    }
    
    // Manual Cropping
    @IBAction private func manualCropButtonTapped(_ sender: UIButton) {
        do {
            
            // Get the page
            let page = try document.page(at: 0)
            
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
            try SBSDKUI2CroppingViewController.present(on: self,
                                                       configuration: configuration) { _, _, error in
                    
                if let sdkError = error as? SBSDKError, sdkError.isCanceled {
                    
                    // The user cancelled the cropping. Do nothing.
                    
                } else if let error {
                    
                    // An error occurred. Show an error alert.
                    self.sbsdk_showError(error)
                    
                } else {
                    
                    // The screen is dismissed without errors.
                    self.singlePageImageView.image = try? page.documentImage?.toUIImage()
                    
                }
            }
        } catch {
            self.sbsdk_showError(error)
        }
    }
    
    // Document Quality analysis
    @IBAction private func analyzeDocumentQualityButtonTapped(_ sender: UIButton) {
        
        do {
            // Get the cropped image
            guard let documentPageImage = try document.page(at: 0).documentImage else { return }
            
            // Initialize document quality analyzer
            let documentAnalyzer = try SBSDKDocumentQualityAnalyzer()
            
            // Get the document quality analysis result by passing the image to the analyzer
            let documentQualityResult = try documentAnalyzer.run(image: documentPageImage)
            
            let documentQuality = map(documentQualityResult.quality)
        
            documentQualityLabel.text = "Document Quality: \(documentQuality)"
            
        } catch {
            
            // An error has occurred. Show an error alert.
            sbsdk_showError(error)
        }
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
        
        do {
            let page = try document.page(at: 0)
            if let pngData = try page.documentImage?.toUIImage().pngData() {
                try pngData.write(to: pngURL)

                // Present the share screen
                share(url: pngURL)
            }
        }
        catch {
            // An error has occurred. Show an error alert.
            sbsdk_showError(error)
        }
    }
    
    // Export to JPG
    private func exportJPG() {
        
        // Set the name and path for the jpg file
        let name = "ScanbotSDK_JPG_Example.jpg"
        let jpgURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent(name)
        
        do {
            if let jpgData = try document.page(at: 0).documentImage?.toUIImage().jpegData(compressionQuality: 0.8) {
                try jpgData.write(to: jpgURL)

                // Present the share screen
                share(url: jpgURL)
            }
        }
        catch {
            // An error has occurred. Show an error alert.
            sbsdk_showError(error)
        }
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

        do {
            // Renders the document into a searchable PDF at the specified file url
            let generator = try SBSDKPDFGenerator(configuration: configuration,
                                                  ocrConfiguration: options,
                                                  useEncryptionIfAvailable: false)
            
            // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
            let progress = generator.generate(from: document, output: pdfURL) { finished, error in
                
                if finished && error == nil {
                    
                    // Present the share screen
                    self.share(url: pdfURL)

                } else if let error {

                    // An error has occurred. Show an error alert.
                    self.sbsdk_showError(error)
                }
            }
        } catch {
            
            // An error has occurred. Show an error alert.
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
            
            // An error has occurred. Show an error alert.
            sbsdk_showError(error)
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
