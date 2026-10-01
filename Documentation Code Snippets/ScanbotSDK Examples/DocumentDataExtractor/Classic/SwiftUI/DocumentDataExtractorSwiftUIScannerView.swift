//
//  DocumentDataExtractorSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `DocumentDataExtractorViewController`.
//

import SwiftUI
import ScanbotSDK

struct DocumentDataExtractorSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKDocumentDataExtractorViewController`.
    @State private var viewModel: SBSDKDocumentDataExtractorViewModel = {

        // To create a list of accepted document types.
        var acceptedTypes = [String]()

        // To extract German ID cards.
        acceptedTypes.append(SBSDKDocumentsModelConstants.deIdCardFrontDocumentType)
        acceptedTypes.append(SBSDKDocumentsModelConstants.deIdCardBackDocumentType)

        // Extracts German passports. Front side only.
        acceptedTypes.append(SBSDKDocumentsModelConstants.dePassportDocumentType)

        // Extracts European driver's licenses only. Front and/or back side.
        acceptedTypes.append(SBSDKDocumentsModelConstants.europeanDriverLicenseFrontDocumentType)
        acceptedTypes.append(SBSDKDocumentsModelConstants.europeanDriverLicenseBackDocumentType)

        // To exclude field types from the extraction process.
        let excludedTypes = [SBSDKDocumentsModelConstants.mrzGenderFieldNormalizedName,
                             SBSDKDocumentsModelConstants.mrzIssuingAuthorityFieldNormalizedName,
                             SBSDKDocumentsModelConstants.deIdCardFrontNationalityFieldNormalizedName]

        // Create a configuration instance using the excluded and accepted document types.
        let configuration = SBSDKDocumentDataExtractorConfiguration(
            fieldExcludeList: excludedTypes,
            configurations: [SBSDKDocumentDataExtractorCommonConfiguration(acceptedDocumentTypes: acceptedTypes)]
        )

        // Enable the crops image extraction.
        configuration.returnCrops = true

        let viewModel = try! SBSDKDocumentDataExtractorViewModel(scannerConfiguration: configuration)

        // Turn the flashlight on/off.
        viewModel.camera.isTorchLightEnabled = false

        // Configure the viewfinder.
        // Enable the view finder.
        viewModel.configuration.viewFinder.isViewFinderEnabled = true

        // Configure the view finder colors and line properties.
        viewModel.configuration.viewFinder.lineColor = UIColor.red
        viewModel.configuration.viewFinder.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        viewModel.configuration.viewFinder.lineWidth = 2
        viewModel.configuration.viewFinder.lineCornerRadius = 8

        return viewModel
    }()

    var body: some View {

        // Embed the `SBSDKDocumentDataExtractorViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKDocumentDataExtractorViewControllerDelegate`.
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .validResult(let result, _):
                    // Access the document's fields directly by iterating over the document's fields.
                    result.document?.fields.forEach { field in
                        // Print field type name, field text and field confidence to the console.
                        print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
                    }

                    // Get the cropped image.
                    let croppedImage = try? result.croppedImage?.toUIImage()

                    // Or get a field by its name.
                    if let nameField = result.document?.field(by: "Surname") {
                        // Access various properties of the field.
                        let fieldTypeName = nameField.type.name
                        let fieldValue = nameField.value?.text
                        let confidence = nameField.value?.confidence
                    }

                    // Or create a wrapper for the document if needed.
                    // You must cast it to the specific wrapper subclass.
                    if let wrapper = result.document?.wrap() as? SBSDKDocumentsModelDeIdCardFront {
                        // Access the document's fields easily through the wrapper.
                        let fieldTypeName = wrapper.surname?.type.name
                        let fieldValue = wrapper.surname?.value?.text
                        let confidence = wrapper.surname?.value?.confidence
                    }

                case .everyFrame:
                    // Fired for every processed frame, regardless of validity; nothing to do here.
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error extracting document data: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    DocumentDataExtractorSwiftUIScannerView()
}
