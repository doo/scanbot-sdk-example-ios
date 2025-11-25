//
//  DocumentDataExtractorLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class DocumentDataExtractorLocalizationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2DocumentDataExtractorViewController.present(on: self,
                                                                                       configuration: configuration)
            // Handle the result.
            
            // Cast the resulted generic document to the appropriate document model using the `wrap` method.
            if let genericDocument = result.document, let wrapper = genericDocument.wrap() {
                // Use SBSDKDocumentsModelDeIdCardFront for German ID card front side
                if let idCardFront = wrapper as? SBSDKDocumentsModelDeIdCardFront {
                    // Retrieve values from the German ID card front
                    if let birthDate = idCardFront.birthDate?.value {
                        print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                    }
                    if let birthplace = idCardFront.birthplace?.value {
                        print("Birthplace: \(birthplace.text), Confidence: \(birthplace.confidence)")
                    }
                    if let cardAccessNumber = idCardFront.cardAccessNumber?.value {
                        print("Card access number: \(cardAccessNumber.text), Confidence: \(cardAccessNumber.confidence)")
                    }
                    if let expiryDate = idCardFront.expiryDate?.value {
                        print("Expiry date: \(expiryDate.text), Confidence: \(expiryDate.confidence)")
                    }
                    if let givenNames = idCardFront.givenNames?.value {
                        print("Given names: \(givenNames.text), Confidence: \(givenNames.confidence)")
                    }
                    if let id = idCardFront.id?.value {
                        print("ID: \(id.text), Confidence: \(id.confidence)")
                    }
                    if let maidenName = idCardFront.maidenName?.value {
                        print("Maiden name: \(maidenName.text), Confidence: \(maidenName.confidence)")
                    }
                    if let nationality = idCardFront.nationality?.value {
                        print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                    }
                    if let surname = idCardFront.surname?.value {
                        print("Surname: \(surname.text), Confidence: \(surname.confidence)")
                    }
                    if let series = idCardFront.series?.value {
                        print("Series: \(series.text), Confidence: \(series.confidence)")
                    }
                    // Note: photo and signature are image fields and might need special handling
                } else {
                    // Handle other document types
                    print("Document detected, but not a German ID card front")
                    // Access available fields from the document
                    if let fields = genericDocument.allFields(includeEmptyFields: false) {
                        for field in fields {
                            if let value = field.value {
                                print("\(field.type.name): \(value.text), Confidence: \(value.confidence)")
                            }
                        }
                    }
                    // Other document types can be added as needed (passport, driver license, etc.)
                }
            }
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error extracting document data: \(error.localizedDescription)")
        }
    }
}
