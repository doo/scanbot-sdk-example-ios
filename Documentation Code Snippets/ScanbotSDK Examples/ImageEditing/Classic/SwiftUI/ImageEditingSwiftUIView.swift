//
//  ImageEditingSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ImageEditingSwiftUIView: View {

    // Image to edit.
    private var editingImage: UIImage?

    @State private var viewModel: SBSDKImageEditingViewModel?
    @State private var didCreateViewModel = false

    var body: some View {
        VStack(spacing: 0) {
            if let viewModel {
                HStack {
                    // Create a custom cancel button.
                    Button("Cancel") {
                        print("Error occurred while editing the image: \(SBSDKError.operationCanceled("The image editing was canceled by the user.").localizedDescription)")
                        self.viewModel = nil
                    }

                    Spacer()

                    // Create a custom save button.
                    Button("Save") {
                        applyChanges(viewModel)
                    }
                }
                .padding()

                SBSDKImageEditingView(viewModel: viewModel)

                HStack {
                    // Create a custom button for counter-clockwise rotation.
                    Button("Rotate counter-clockwise") {
                        rotate(viewModel, clockwise: false)
                    }

                    Spacer()

                    // Create a custom button for clockwise rotation.
                    Button("Rotate clockwise") {
                        rotate(viewModel, clockwise: true)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            createViewModelIfNeeded()
        }
    }

    func createViewModelIfNeeded() {
        guard !didCreateViewModel else { return }
        didCreateViewModel = true

        // Check if the image to edit is not nil.
        guard let image = self.editingImage else { return }

        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)

        // Create the page.
        let page = SBSDKDocumentPage(image: imageRef, polygon: nil, parametricFilters: .none)

        let viewModel = SBSDKImageEditingViewModel(image: page.originalPreviewImage!, polygon: page.polygon)
        viewModel.onFailure = { error in
            print("Error occurred while editing the image: \(error.localizedDescription)")

            self.viewModel = nil
        }
        self.viewModel = viewModel
    }

    func rotate(_ viewModel: SBSDKImageEditingViewModel, clockwise: Bool) {
        do {
            try viewModel.rotateInputImageClockwise(clockwise, animated: true)
        } catch {
            // Handle the error.
            print("Error occurred while editing the image: \(error.localizedDescription)")

            self.viewModel = nil
        }
    }

    func applyChanges(_ viewModel: SBSDKImageEditingViewModel) {
        do {
            let croppedImage = try viewModel.outputImage(croppingEnabled: viewModel.isCropEnabled)
            let polygon = viewModel.polygon

            // Process the edited image.
            self.viewModel = nil
        } catch {
            // Handle the error.
            print("Error occurred while editing the image: \(error.localizedDescription)")

            self.viewModel = nil
        }
    }
}

#Preview {
    ImageEditingSwiftUIView()
}
