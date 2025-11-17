//
//  DocumentDataExtractorPaletteUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 30.01.25.
//

import UIKit
import ScanbotSDK

class DocumentDataExtractorPaletteUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()
        
        // Retrieve the instance of the palette from the configuration object.
        let palette = configuration.palette
        
        // Configure the colors.
        // The palette already has the default colors set, so you don't have to always set all the colors.
        palette.sbColorPrimary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorPrimaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorNegative = SBSDKUI2Color(colorString: "#FF3737")
        palette.sbColorPositive = SBSDKUI2Color(colorString: "#4EFFB4")
        palette.sbColorWarning = SBSDKUI2Color(colorString: "#FFCE5C")
        palette.sbColorSecondary = SBSDKUI2Color(colorString: "#FFEDEE")
        palette.sbColorSecondaryDisabled = SBSDKUI2Color(colorString: "#F5F5F5")
        palette.sbColorOnPrimary = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOnSecondary = SBSDKUI2Color(colorString: "#C8193C")
        palette.sbColorSurface = SBSDKUI2Color(colorString: "#FFFFFF")
        palette.sbColorOutline = SBSDKUI2Color(colorString: "#EFEFEF")
        palette.sbColorOnSurfaceVariant = SBSDKUI2Color(colorString: "#707070")
        palette.sbColorOnSurface = SBSDKUI2Color(colorString: "#000000")
        palette.sbColorSurfaceLow = SBSDKUI2Color(colorString: "#26000000")
        palette.sbColorSurfaceHigh = SBSDKUI2Color(colorString: "#7A000000")
        palette.sbColorModalOverlay = SBSDKUI2Color(colorString: "#A3000000")
        
        // Present the view controller modally.
        SBSDKUI2DocumentDataExtractorViewController.present(on: self,
                                                   configuration: configuration) { controller, result, error in
            if let error {
                
                // Handle the error.
                print("Error extracting document data: \(error.localizedDescription)")
                
            } else if let result {
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
                    }
                    // Other document types can be added as needed (passport, driver license, etc.)
                }
            }
        }
    }
}
