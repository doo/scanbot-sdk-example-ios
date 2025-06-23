//
//  ReviewViewController.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 07.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class ReviewableScanResult {
    var images = [UIImage]()
}

final class ReviewViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView?
    @IBOutlet private var clearButton: UIBarButtonItem?
    @IBOutlet private var toolbar: UIToolbar?
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    var result: ReviewableScanResult!
    
    private static var showsQuality: Bool = false
    private static var qualityCache = [URL: SBSDKDocumentQuality]()
    
    private var showsQuality: Bool = showsQuality {
        didSet {
            Self.showsQuality = showsQuality
            if isViewLoaded { reloadData() }
        }
    }
    
    class func make(with result: ReviewableScanResult) -> ReviewViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController")
        as! ReviewViewController
        viewController.result = result
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        toolbar?.isTranslucent = false
        reloadData()
    }
    
    @IBAction private func clearButtonDidPress(_ sender: Any) {
        result.images = []
        reloadData()
    }
    
    private func reloadData() {
        collectionView?.reloadData()
        clearButton?.isEnabled = result.images.count > 0
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentReviewCollectionViewCell", for: indexPath) as!
        ReviewCollectionViewCell
        let image = result.images[indexPath.item]
        cell.previewImageView?.image = image
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ReviewViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
