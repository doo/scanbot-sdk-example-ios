//
//  UsecasesListTableViewController.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import UIKit

final class UsecasesListTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            // Present single page document scanner on this table view controller
            SinglePageScanning.present(presenter: self)
            
        } else if indexPath.row == 1 {
            
            // Present multiple page document scanner on this table view controller
            MultiplePageScanning.present(presenter: self)
            
        } else if indexPath.row == 2 {
            
            // Present single page scanner with finder overlay on this table view controller
            SinglePageFinderOverlayScanning.present(presenter: self)
            
        } else if indexPath.row == 3 {
            
            // Navigate to detection on image view controller
            navigationController?.pushViewController(PickFromGalleryViewController.make(),
                                                     animated: true)
        }
    }
}
