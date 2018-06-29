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
    private(set) var pages: [SBSDKUIPage] = []

    private var imageCache = NSCache<NSString, UIImage>()
    
    class func createNewWithPages(_ pages: [SBSDKUIPage], andDelegate delegate: ImageBrowserViewControllerDelegate)
        -> ImageBrowserViewController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let browser = storyboard.instantiateViewController(withIdentifier: "ImageBrowserViewController")
                as! ImageBrowserViewController
            browser.delegate = delegate
            browser.pages = pages
            return browser
    }
    
    class func presentOn(_ presenter: UIViewController,
                         withPages pages: [SBSDKUIPage],
                         andDelegate delegate: ImageBrowserViewControllerDelegate) -> ImageBrowserViewController {
        
        let browser = self.createNewWithPages(pages, andDelegate: delegate)
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
    
    private func thumbnailImageForID(_ uuid: UUID) -> UIImage? {
        var image = self.imageCache.object(forKey: uuid.uuidString as NSString)
        if image != nil {
            return image
        }
        image = SBSDKUIPageFileStorage.default().previewImage(withPageFileID: uuid,
                                                              pageFileType: SBSDKUIPageFileType.document)
        if let image = image {
            self.imageCache.setObject(image, forKey: uuid.uuidString as NSString)
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
        return self.pages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath)
            as! ImageBrowserCollectionViewCell
        
        let page = self.pages[indexPath.row]
        cell.imageView.image = self.thumbnailImageForID(page.pageFileUUID)
        return cell
    }
}

extension ImageBrowserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let page = self.pages[indexPath.item]
        self.delegate?.imageBrowser(self, didSelectPage: page)
    }
}

extension ImageBrowserViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            let page = self.pages[indexPath.item]
            let _ = self.thumbnailImageForID(page.pageFileUUID)
        }
    }
}
