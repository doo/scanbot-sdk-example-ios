//
//  ImageEditingViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.09.21.
//

import UIKit
import ScanbotSDK

class ImageEditingViewController: UIViewController {

    // Image to edit.
    var editingImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if the image to edit is not nil.
        guard let image = self.editingImage else { return }
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Create the page.
        let page = SBSDKDocumentPage(image: imageRef, polygon: nil, parametricFilters: .none)

        do {
            // Create the editing view controller.
            let editingViewController = try SBSDKImageEditingViewController.create(page: page)
            
            // Set self as the delegate.
            editingViewController.delegate = self
            
            // Create and set up a navigation controller to present control buttons.
            let navigationController = UINavigationController(rootViewController: editingViewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            // Present the editing screen modally.
            self.present(navigationController, animated: true, completion: nil)
        }
        catch {
            print("Error occurred while editing the image: \(error.localizedDescription)")
        }
    }
}

extension ImageEditingViewController: SBSDKImageEditingViewControllerDelegate {
    
    func imageEditingViewControllerDidFail(_ editingViewController: SBSDKImageEditingViewController,
                                           with error: any Error) {
        // Handle the error.
        print("Error occurred while editing the image: \(error.localizedDescription)")
    }
    
    // Create a custom cancel button.
    func imageEditingViewControllerCancelButtonItem(_ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
        return UIBarButtonItem(systemItem: .cancel)
    }

    // Create a custom save button.
    func imageEditingViewControllerApplyButtonItem(_ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
        return UIBarButtonItem(systemItem: .save)
    }

    // Create a custom button for clockwise rotation.
    func imageEditingViewControllerRotateClockwiseToolbarItem(_ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
        return UIBarButtonItem(title: "Rotate clockwise",
                               style: .plain,
                               target: nil,
                               action: nil)
    }

    // Create a custom button for counter-clockwise rotation.
    func imageEditingViewControllerRotateCounterClockwiseToolbarItem(_ editingViewController: SBSDKImageEditingViewController) -> UIBarButtonItem? {
        return UIBarButtonItem(title: "Rotate counter-clockwise",
                               style: .plain,
                               target: nil,
                               action: nil)
    }

    // Handle canceling the changes.
    func imageEditingViewControllerDidCancelChanges(_ editingViewController: SBSDKImageEditingViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    // Handle applying the changes.
    func imageEditingViewController(_ editingViewController: SBSDKImageEditingViewController,
                                    didApplyChangesWith polygon: SBSDKPolygon, croppedImage: UIImage) {
        // Process the edited image.
        self.dismiss(animated: true, completion: nil)
    }
}
