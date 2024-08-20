//
//  UsecaseFilterPage.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseFilterPage: Usecase {
    
    private let document: SBSDKDocument
    private var completion: (()->())?
    private var barButtonItem: UIBarButtonItem?
    
    init(document: SBSDKDocument,
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
                    for index in 0..<(self?.document.pages.count ?? 0) {
                        self?.document.page(at: index)?.parametricFilters = [SBSDKLegacyFilter(filterType: filterType.rawValue)]
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
            .none,
            .color,
            .gray,
            .pureGray,
            .binarized,
            .colorDocument,
            .pureBinarized,
            .backgroundClean,
            .blackAndWhite,
            .otsuBinarization,
            .deepBinarization,
            .edgeHighlight,
            .lowLightBinarization,
            .lowLightBinarization2
        ]
        
        static func name(for filter: SBSDKImageFilterType) -> String {
            switch filter {
            case .none:
                return "None"
            case .color:
                return "Color"
            case .gray:
                return "Optimized greyscale"
            case .pureGray:
                return "Pure greyscale"
            case .binarized:
                return "Binarized"
            case .colorDocument:
                return "Color document"
            case .pureBinarized:
                return "Pure binarized"
            case .backgroundClean:
                return "Background clean"
            case .blackAndWhite:
                return "Black & white"
            case .otsuBinarization:
                return "Otsu binarization"
            case .deepBinarization:
                return "Deep binarization"
            case .edgeHighlight:
                return "Edge highlight"
            case .lowLightBinarization:
                return "Low light binarization"
            case .lowLightBinarization2:
                return "Low light binarization 2"
            default: return "UNKNOWN"
            }
        }
    }
}
