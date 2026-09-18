//
//  DocumentCleanupCustomUIViewController.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

class DocumentCleanupCustomUIViewController: UIViewController,
                                             UIImagePickerControllerDelegate,
                                             UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present an image picker. In a real application this is usually triggered by a button.
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) {
            do {
                try self.presentCleanupCanvas(with: pickedImage)
            }
            catch {
                print("Error occurred while creating the cleanup canvas: \(error.localizedDescription)")
            }
        }
    }
    
    func presentCleanupCanvas(with pickedImage: UIImage) throws {
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
        
        // Create the configuration of the underlying cleanup engine.
        let configuration = SBSDKDocumentCleanupConfiguration()
        
        // Preserve detected text. Enabling it runs text detection, which can be time-consuming.
        configuration.keepText = true
        
        // Maximum number of undo/redo steps kept in memory.
        configuration.maxUndoRedoStackSize = 10
        
        // Create the view model that owns the cleanup state, the undo/redo history and the stroke settings.
        let viewModel = try SBSDKDocumentCleanupCanvasViewModel(image: imageRef, configuration: configuration)
        
        // Host the custom SwiftUI cleanup screen.
        let hostingController = UIHostingController(rootView: DocumentCleanupCustomUIView(viewModel: viewModel))
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
}

// The custom cleanup screen. `SBSDKDocumentCleanupCanvas` renders the image, handles the
// painting and the pinch-to-zoom gestures. All surrounding chrome - top bar, toolbar,
// undo / redo / reset controls and stroke size slider - is fully owned by the application.
struct DocumentCleanupCustomUIView: View {
    
    // The view model driving the canvas. It publishes the current image, the processing state
    // and the undo/redo availability, and receives the cleanup actions.
    @ObservedObject var viewModel: SBSDKDocumentCleanupCanvasViewModel
    
    // The error message of the last failed cleanup operation, if any.
    @State private var errorMessage: String?
    
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
                errorMessage = error.localizedDescription
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
