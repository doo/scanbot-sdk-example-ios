//
//  ZoomingImageSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ZoomingImageSwiftUIView: View {

    @StateObject private var viewModel = SBSDKZoomingImageViewModel(image: UIImage(named: "documentImage"))

    var body: some View {
        VStack(spacing: 16) {
            SBSDKZoomingImageView(viewModel: viewModel)

            HStack(spacing: 24) {
                Button("Left") { viewModel.panLeft() }
                    .disabled(!viewModel.canPanLeft)
                Button("Right") { viewModel.panRight(by: 0.5) }
                    .disabled(!viewModel.canPanRight)
                Button("Up") { viewModel.panUp() }
                    .disabled(!viewModel.canPanUp)
                Button("Down") { viewModel.panDown() }
                    .disabled(!viewModel.canPanDown)
            }

            HStack(spacing: 24) {
                Button("Zoom In") { viewModel.zoomIn() }
                    .disabled(!viewModel.canZoomIn)
                Button("Zoom Out") { viewModel.zoomOut() }
                    .disabled(!viewModel.canZoomOut)
                Button("Reset") { viewModel.reset() }
            }
        }
        .padding()
    }
}

#Preview {
    ZoomingImageSwiftUIView()
}
