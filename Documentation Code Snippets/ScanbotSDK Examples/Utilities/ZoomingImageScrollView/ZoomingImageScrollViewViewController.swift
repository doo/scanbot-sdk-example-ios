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
        
        // We instantiate our new class helper.
        imageViewWithZoom = SBSDKZoomingImageScrollView()
        
        // We set the desired image.
        imageViewWithZoom?.image = image
        
        // We can add some margins.
        imageViewWithZoom?.margins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        // We set an overlay on top of our image.
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        imageViewWithZoom?.overlayView = overlayView
        
        // We add our view to the subview with our desired constraints.
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
