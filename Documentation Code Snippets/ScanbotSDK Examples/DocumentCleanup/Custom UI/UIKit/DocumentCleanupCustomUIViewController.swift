//
//  DocumentCleanupCustomUIViewController.swift
//  ScanbotSDK Examples
//

import UIKit
import SwiftUI
import ScanbotSDK

class DocumentCleanupCustomUIViewController: UIViewController,
                                             UIImagePickerControllerDelegate,
                                             UINavigationControllerDelegate {
    
    // The view model that owns the cleanup state, the undo/redo history and the stroke settings.
    private var viewModel: SBSDKDocumentCleanupCanvasViewModel?
    
    // The observations of the view model's state, used to keep the controls in sync.
    private var observations = [NSKeyValueObservation]()
    
    private let undoButton = UIButton(type: .system)
    private let redoButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let strokeSizeLabel = UILabel()
    private let strokeSizeSlider = UISlider()
    private let progressView = UIProgressView(progressViewStyle: .bar)
    
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
                try self.showCleanupCanvas(with: pickedImage)
            }
            catch {
                print("Error occurred while creating the cleanup canvas: \(error.localizedDescription)")
            }
        }
    }
    
    func showCleanupCanvas(with pickedImage: UIImage) throws {
        
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
        self.viewModel = viewModel
        
        // The color of the stroke preview drawn while the user paints.
        viewModel.strokeColor = UIColor.systemRed.withAlphaComponent(0.6)
        
        // Called when a cleanup operation fails.
        viewModel.onFailure = { error in
            print("Cleanup error: \(error.localizedDescription)")
        }
        
        // Called when a cleanup run completed with reduced quality because the affected
        // area exceeded the configured maximum resolution.
        viewModel.onReducedQuality = {
            print("The area was cleaned up with reduced quality.")
        }
        
        // Called when a stroke is rejected because the masked area is too large to process.
        viewModel.onAreaTooLarge = {
            print("The selected area is too large. Please select a smaller area.")
        }
        
        // `SBSDKDocumentCleanupCanvas` renders the image and handles the painting and the
        // pinch-to-zoom gestures. It is a SwiftUI view, so it is embedded in a hosting controller.
        // All surrounding chrome - top bar, toolbar, undo / redo / reset controls and stroke size
        // slider - is fully owned by the application.
        let canvasController = UIHostingController(rootView: SBSDKDocumentCleanupCanvas(viewModel: viewModel))
        canvasController.view.backgroundColor = .black
        
        addChild(canvasController)
        canvasController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasController.view)
        canvasController.didMove(toParent: self)
        
        setUpControls()
        layOutSubviews(canvasView: canvasController.view)
        observeViewModel(viewModel)
    }
    
    private func setUpControls() {
        
        undoButton.setTitle("Undo", for: .normal)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        redoButton.setTitle("Redo", for: .normal)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        // The stroke size is defined in view points.
        strokeSizeSlider.minimumValue = 8
        strokeSizeSlider.maximumValue = 120
        strokeSizeSlider.addTarget(self, action: #selector(strokeSizeChanged), for: .valueChanged)
        
        progressView.isHidden = true
    }
    
    private func layOutSubviews(canvasView: UIView) {
        
        let buttonsStackView = UIStackView(arrangedSubviews: [undoButton, redoButton, resetButton])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 24
        
        let controlsStackView = UIStackView(arrangedSubviews: [buttonsStackView,
                                                              strokeSizeLabel,
                                                              strokeSizeSlider,
                                                              doneButton])
        controlsStackView.axis = .vertical
        controlsStackView.spacing = 8
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controlsStackView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: controlsStackView.topAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: canvasView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
            
            controlsStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            controlsStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            controlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func observeViewModel(_ viewModel: SBSDKDocumentCleanupCanvasViewModel) {
        
        // `isProcessing` is `true` while a cleanup operation is running.
        observations = [
            viewModel.observe(\.isProcessing, options: [.initial, .new]) { [weak self] _, _ in
                self?.updateControls()
            },
            viewModel.observe(\.canUndo, options: [.initial, .new]) { [weak self] _, _ in
                self?.updateControls()
            },
            viewModel.observe(\.canRedo, options: [.initial, .new]) { [weak self] _, _ in
                self?.updateControls()
            },
            viewModel.observe(\.strokeSize, options: [.initial, .new]) { [weak self] _, _ in
                self?.updateControls()
            }
        ]
    }
    
    private func updateControls() {
        
        guard let viewModel else { return }
        
        undoButton.isEnabled = viewModel.canUndo && !viewModel.isProcessing
        redoButton.isEnabled = viewModel.canRedo && !viewModel.isProcessing
        resetButton.isEnabled = viewModel.canUndo && !viewModel.isProcessing
        
        strokeSizeLabel.text = "Stroke size: \(Int(viewModel.strokeSize))"
        strokeSizeSlider.value = Float(viewModel.strokeSize)
        
        progressView.isHidden = !viewModel.isProcessing
    }
    
    @objc private func undo() {
        viewModel?.undo()
    }
    
    @objc private func redo() {
        viewModel?.redo()
    }
    
    @objc private func reset() {
        viewModel?.reset()
    }
    
    @objc private func strokeSizeChanged() {
        viewModel?.strokeSize = CGFloat(strokeSizeSlider.value)
    }
    
    @objc private func done() {
        
        guard let viewModel else { return }
        
        // Retrieve the cleaned up image, e.g. to store or share it.
        let cleanedImageRef = viewModel.currentImageRefSnapshot()
        let cleanedImage = try? cleanedImageRef.toUIImage()
    }
}
