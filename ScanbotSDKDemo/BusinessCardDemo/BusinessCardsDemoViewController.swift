//
//  BusinessCardsDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BusinessCardsDemoViewController: UIViewController {
    private var scannerViewController: SBSDKMultipleObjectScannerViewController?
    
    
}

extension BusinessCardsDemoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}

extension BusinessCardsDemoViewController: SBSDKMultipleObjectScannerViewControllerDelegate {
    
}
