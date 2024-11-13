//
//  ZoomingImageScrollViewViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

import UIKit
import ScanbotSDK

class ZoomingImageScrollViewViewController: UIViewController {
    
    var imageViewWithZoom: SBSDKZoomingImageScrollView?
    let image = UIImage(named: "documentImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate the zooming image scroll view.
        imageViewWithZoom = SBSDKZoomingImageScrollView()
        
        // Set the image you want to zoom into and scroll.
        imageViewWithZoom?.image = image
        
        // Add some margins if needed. 
        imageViewWithZoom?.margins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        // Place a transparent overlay on top of our image.
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        imageViewWithZoom?.overlayView = overlayView
        
        // Add the zooming image scroll view to the view hierarchy and setup its constraints as needed.
        imageViewWithZoom?.translatesAutoresizingMaskIntoConstraints = false
        if let imageViewWithZoom = imageViewWithZoom {
            self.view.addSubview(imageViewWithZoom)
            if let image = image {
                let ratio = image.size.width / image.size.height
                imageViewWithZoom.widthAnchor.constraint(equalToConstant: 320).isActive = true
                imageViewWithZoom.heightAnchor.constraint(equalToConstant: 320 / ratio).isActive = true
                imageViewWithZoom.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                imageViewWithZoom.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            }
        }
    }
}
