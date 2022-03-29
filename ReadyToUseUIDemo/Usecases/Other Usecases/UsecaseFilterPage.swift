//
//  UsecaseFilterPage.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseFilterPage: Usecase {
    
    private let document: SBSDKUIDocument
    private var completion: (()->())?
    private var barButtonItem: UIBarButtonItem?
    
    init(document: SBSDKUIDocument,
         barButtonItem: UIBarButtonItem?,
         completion: (()->())? = nil) {
        self.document = document
        self.completion = completion
        self.barButtonItem = barButtonItem
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        FilterManager.filters.forEach { filterType in
            let action = UIAlertAction(title: FilterManager.name(for: filterType),
                                       style: .default) { [weak self] _ in
                DispatchQueue(label: "FilterQueue").async {
                    for index in 0..<(self?.document.numberOfPages() ?? 0) {
                        self?.document.page(at: index)?.filter = filterType
                    }
                }
                DispatchQueue.main.async {
                    self?.completion?()
                    self?.didFinish()
                }
            }
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.didFinish()
        }
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.barButtonItem = self.barButtonItem

        presentViewController(alert)
    }
    
    private struct FilterManager {
        static let filters: [SBSDKImageFilterType] = [
            SBSDKImageFilterTypeNone,
            SBSDKImageFilterTypeColor,
            SBSDKImageFilterTypeGray,
            SBSDKImageFilterTypePureGray,
            SBSDKImageFilterTypeBinarized,
            SBSDKImageFilterTypeColorDocument,
            SBSDKImageFilterTypePureBinarized,
            SBSDKImageFilterTypeBackgroundClean,
            SBSDKImageFilterTypeBlackAndWhite,
            SBSDKImageFilterTypeOtsuBinarization,
            SBSDKImageFilterTypeDeepBinarization,
            SBSDKImageFilterTypeEdgeHighlight,
            SBSDKImageFilterTypeLowLightBinarization,
            SBSDKImageFilterTypeLowLightBinarization2
        ]
        
        static func name(for filter: SBSDKImageFilterType) -> String {
            switch filter {
            case SBSDKImageFilterTypeNone:
                return "None"
            case SBSDKImageFilterTypeColor:
                return "Color"
            case SBSDKImageFilterTypeGray:
                return "Optimized greyscale"
            case SBSDKImageFilterTypePureGray:
                return "Pure greyscale"
            case SBSDKImageFilterTypeBinarized:
                return "Binarized"
            case SBSDKImageFilterTypeColorDocument:
                return "Color document"
            case SBSDKImageFilterTypePureBinarized:
                return "Pure binarized"
            case SBSDKImageFilterTypeBackgroundClean:
                return "Background clean"
            case SBSDKImageFilterTypeBlackAndWhite:
                return "Black & white"
            case SBSDKImageFilterTypeOtsuBinarization:
                return "Otsu binarization"
            case SBSDKImageFilterTypeDeepBinarization:
                return "Deep binarization"
            case SBSDKImageFilterTypeEdgeHighlight:
                return "Edge highlight"
            case SBSDKImageFilterTypeLowLightBinarization:
                return "Low light binarization"
            case SBSDKImageFilterTypeLowLightBinarization2:
                return "Low light binarization 2"
            default: return "UNKNOWN"
            }
        }
    }
}
