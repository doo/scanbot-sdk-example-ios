//
//  ImageBrowserViewController.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

protocol ImageBrowserViewControllerDelegate: class {
    func imageBrowser(_ imageBrowser: ImageBrowserViewController, didSelectPage page: SBSDKUIPage)
}

class ImageBrowserViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionLayout: UICollectionViewFlowLayout!
    
    weak var delegate: ImageBrowserViewControllerDelegate?
    private(set) var document = SBSDKUIDocument()

    private var imageCache = NSCache<NSString, UIImage>()
    
    class func createNewWithDocument(_ document: SBSDKUIDocument, andDelegate delegate: ImageBrowserViewControllerDelegate)
        -> ImageBrowserViewController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let browser = storyboard.instantiateViewController(withIdentifier: "ImageBrowserViewController")
                as! ImageBrowserViewController
            browser.delegate = delegate
            browser.document = document
            return browser
    }
    
    class func presentOn(_ presenter: UIViewController,
                         withDocument document: SBSDKUIDocument,
                         andDelegate delegate: ImageBrowserViewControllerDelegate) -> ImageBrowserViewController {
        
        let browser = self.createNewWithDocument(document, andDelegate: delegate)
        presenter.present(browser, animated: true, completion: nil)
        return browser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pages"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageCache =  NSCache<NSString, UIImage>()
        self.collectionView.reloadData()
    }
    
    private func thumbnailImageForPage(_ page: SBSDKUIPage) -> UIImage? {
        var image = self.imageCache.object(forKey: page.pageFileUUID.uuidString as NSString)
        if image != nil {
            return image
        }
        image = page.documentPreviewImage()
        if let image = image {
            self.imageCache.setObject(image, forKey: page.pageFileUUID.uuidString as NSString)
        }
        return image
    }
}

extension ImageBrowserViewController {
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ImageBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.document.numberOfPages()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
            as! ImageBrowserCollectionViewCell
        
        if let page = self.document.page(at: indexPath.item) {
            cell.imageView.image = self.thumbnailImageForPage(page)
        }
        return cell
    }
}

extension ImageBrowserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        if let page = self.document.page(at: indexPath.item) {
            self.delegate?.imageBrowser(self, didSelectPage: page)
        }
    }
}

extension ImageBrowserViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            if let page = self.document.page(at: indexPath.item) {
                let _ = self.thumbnailImageForPage(page)
            }
        }
    }
}
