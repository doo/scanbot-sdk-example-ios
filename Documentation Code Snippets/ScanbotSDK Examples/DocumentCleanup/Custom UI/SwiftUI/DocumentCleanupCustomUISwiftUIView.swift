//
//  DocumentCleanupCustomUISwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentCleanupCustomUISwiftUIView: View {
    
    // The view model that owns the cleanup state, the undo/redo history and the stroke settings.
    @State private var viewModel: SBSDKDocumentCleanupCanvasViewModel?
    
    // The message of the last error, if any.
    @State private var errorMessage: String?
    
    var body: some View {
        
        if let viewModel {
            
            // The custom cleanup screen. `SBSDKDocumentCleanupCanvas` renders the image, handles the
            // painting and the pinch-to-zoom gestures. All surrounding chrome - top bar, toolbar,
            // undo / redo / reset controls and stroke size slider - is fully owned by the application.
            DocumentCleanupCustomUICanvasView(viewModel: viewModel, errorMessage: $errorMessage)
            
        } else if let errorMessage {
            
            // Show error view here.
            Text("Error occurred while creating the cleanup canvas: \(errorMessage)")
            
        } else {
            
            // Present an image picker.
            ExampleImagePicker { pickedImage in
                prepareCleanupCanvas(with: pickedImage)
            }
        }
    }
    
    func prepareCleanupCanvas(with pickedImage: UIImage) {
        
        do {
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
            
            // Create the configuration of the underlying cleanup engine.
            let configuration = SBSDKDocumentCleanupConfiguration()
            
            // Preserve detected text. Enabling it runs text detection, which can be time-consuming.
            configuration.keepText = true
            
            // Maximum number of undo/redo steps kept in memory.
            configuration.maxUndoRedoStackSize = 10
            
            // Create the view model that owns the cleanup state, the undo/redo history and the stroke settings.
            viewModel = try SBSDKDocumentCleanupCanvasViewModel(image: imageRef, configuration: configuration)
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct DocumentCleanupCustomUICanvasView: View {
    
    // The view model driving the canvas. It publishes the current image, the processing state
    // and the undo/redo availability, and receives the cleanup actions.
    @ObservedObject var viewModel: SBSDKDocumentCleanupCanvasViewModel
    
    // The error message of the last failed cleanup operation, if any.
    @Binding var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                
                // The cleanup canvas itself.
                SBSDKDocumentCleanupCanvas(viewModel: viewModel)
                    .background(Color.black)
                
                // `isProcessing` is `true` while a cleanup operation is running.
                if viewModel.isProcessing {
                    ProgressView()
                        .progressViewStyle(.linear)
                }
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 24) {
                    Button("Undo") { viewModel.undo() }
                        .disabled(!viewModel.canUndo || viewModel.isProcessing)
                    
                    Button("Redo") { viewModel.redo() }
                        .disabled(!viewModel.canRedo || viewModel.isProcessing)
                    
                    Button("Reset") { viewModel.reset() }
                        .disabled(!viewModel.canUndo || viewModel.isProcessing)
                }
                
                // The stroke size is defined in view points.
                Text("Stroke size: \(Int(viewModel.strokeSize))")
                Slider(value: $viewModel.strokeSize, in: 8...120)
                
                Button("Done") {
                    // Retrieve the cleaned up image, e.g. to store or share it.
                    let cleanedImageRef = viewModel.currentImageRefSnapshot()
                    let cleanedImage = try? cleanedImageRef.toUIImage()
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .onAppear {
            
            // The color of the stroke preview drawn while the user paints.
            viewModel.strokeColor = UIColor.systemRed.withAlphaComponent(0.6)
            
            // Called when a cleanup operation fails.
            viewModel.onFailure = { error in
                errorMessage = "Cleanup error: \(error.localizedDescription)"
            }
            
            // Called when a cleanup run completed with reduced quality because the affected
            // area exceeded the configured maximum resolution.
            viewModel.onReducedQuality = {
                errorMessage = "The area was cleaned up with reduced quality."
            }
            
            // Called when a stroke is rejected because the masked area is too large to process.
            viewModel.onAreaTooLarge = {
                errorMessage = "The selected area is too large. Please select a smaller area."
            }
        }
    }
}

#Preview {
    DocumentCleanupCustomUISwiftUIView()
}
