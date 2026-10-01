//
//  ExampleImagePicker.swift
//  ScanbotSDK Examples
//

import SwiftUI
import UIKit

struct ExampleImagePicker: UIViewControllerRepresentable {
    
    let didPick: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(didPick: didPick)
    }
    
    final class Coordinator: NSObject,
                             UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate {
        
        private let didPick: (UIImage) -> Void
        
        init(didPick: @escaping (UIImage) -> Void) {
            self.didPick = didPick
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard let pickedImage = info[.originalImage] as? UIImage else { return }
            
            picker.dismiss(animated: true) {
                self.didPick(pickedImage)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
