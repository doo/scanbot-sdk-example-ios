//
//  FilterListViewController.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

final class FilterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var filters = ParametricFilterType.allCases
    private var selectedFilterIndex: IndexPath?
    
    var selectedFilter: ((_ filter: SBSDKParametricFilter) -> Void)?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed, let selectedFilterIndex {
            let selectedType = filters[selectedFilterIndex.row]
            let filter = filter(selectedType: selectedType)
            selectedFilter?(filter)
        }
    }
    
    func filter(selectedType: ParametricFilterType) -> SBSDKParametricFilter {
        
        switch selectedType {
        case .binarization:
            return SBSDKScanbotBinarizationFilter()
        case .customBinarization:
            return SBSDKCustomBinarizationFilter()
        case .colorDocument:
            return SBSDKColorDocumentFilter()
        case .brightness:
            return SBSDKBrightnessFilter(brightness: 0.6)
        case .contrast:
            return SBSDKContrastFilter(contrast: 4)
        case .grayscale:
            return SBSDKGrayscaleFilter()
        case .legacy:
            return SBSDKLegacyFilter(legacyFilter: .lowLightBinarization2)
        case .whiteBlackPoint:
            return SBSDKWhiteBlackPointFilter(blackPoint: 0.6, whitePoint: 0.6)
        }
        
    }
    
    @IBAction private func doneButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterListCell") as! FilterListTableViewCell
        let selected = selectedFilterIndex == indexPath
        cell.setup(filter: filters[indexPath.row], selected: selected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFilterIndex = indexPath
        tableView.reloadData()
    }
}

extension FilterListViewController {
    static func make() -> FilterListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterListViewController = storyboard.instantiateViewController(withIdentifier: "FilterListViewController")
        as! FilterListViewController
        return filterListViewController
    }
}
