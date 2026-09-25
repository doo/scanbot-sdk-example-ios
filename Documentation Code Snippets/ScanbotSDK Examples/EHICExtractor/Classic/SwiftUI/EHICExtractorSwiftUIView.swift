//
//  EHICExtractorSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct EHICExtractorSwiftUIView: View {

    @State private var viewModel: SBSDKDocumentDataExtractorViewModel = {

        // Create the default configuration.
        let ehicConfiguration = SBSDKEuropeanHealthInsuranceCardConfiguration()

        // Modify the configuration to your needs.

        // Although optional, you can set the expected country if needed.
        // If this is set, then the validation rules for the given country are used.
        // If the expected country cannot be inferred or the inferred country doesn't match
        // the given country, the result will be IncompleteValidation.
        ehicConfiguration.expectedCountry = .germany
        
        let configuration = SBSDKDocumentDataExtractorConfiguration(
            configurations: [ehicConfiguration]
        )

        return try! SBSDKDocumentDataExtractorViewModel(scannerConfiguration: configuration)
    }()

    var body: some View {
        SBSDKScannerView(model: viewModel)
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .validResult(let result, _):
                    // Process the result.

                    // Get the status.
                    let status = result.status

                    // Get the detection result.
                    let detectionResult = result.documentDetectionResult

                    // Get the cropped image.
                    let croppedImage = try? result.croppedImage?.toUIImage()

                    // Access the document's fields directly by iterating over them.
                    if let fields = result.document?.fields.compactMap({ "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }) {
                        print(fields.joined(separator: "\n"))
                    }

                case .everyFrame:
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error extracting EHIC data: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    EHICExtractorSwiftUIView()
}
