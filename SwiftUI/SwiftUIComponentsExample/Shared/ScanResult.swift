//
//  ScanResult.swift
//  SwiftUIComponentsExample
//
//  A small, SwiftUI-friendly result model that is shared by all scanner examples.
//

import SwiftUI
import ScanbotSDK

struct ScanResultField: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

struct ScanResult: Identifiable {
    let id = UUID()
    let title: String
    let fields: [ScanResultField]
    let images: [UIImage]
    let rawJSON: String?
    
    init(title: String,
         fields: [ScanResultField] = [],
         images: [UIImage] = [],
         rawJSON: String? = nil) {
        self.title = title
        self.fields = fields
        self.images = images
        self.rawJSON = rawJSON
    }
}

extension ScanResult {
    
    /// Builds a result from a generic document, which is what most data capture scanners return.
    init(title: String,
         document: SBSDKGenericDocument?,
         images: [SBSDKImageRef?] = [],
         extraFields: [ScanResultField] = [],
         rawJSON: String? = nil) {
        self.init(title: title,
                  fields: extraFields + ScanResult.fields(of: document),
                  images: images.compactMap { $0?.asUIImage },
                  rawJSON: rawJSON)
    }
    
    /// Flattens a generic document and all of its children into a plain list of name/value pairs.
    static func fields(of document: SBSDKGenericDocument?) -> [ScanResultField] {
        guard let document else { return [] }
        let own = document.fields.map { field in
            ScanResultField(name: field.type.displayText ?? field.type.name,
                            value: field.value?.text ?? "")
        }
        return own + document.children.flatMap { fields(of: $0) }
    }
}

extension SBSDKImageRef {
    /// Converts the image reference into a `UIImage`, ignoring conversion failures.
    var asUIImage: UIImage? {
        return try? toUIImage()
    }
}
