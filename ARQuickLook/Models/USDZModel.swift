//
//  USDZModel.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 02.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import QuickLookThumbnailing
import UIKit

class USDZModel {
    // MARK: - Static Properties
    static let imageUpdatedNotification = Notification.Name("USDZModel.imageUpdated")
    
    // MARK: - Stored Properties
    private let filename: String
    let url: URL
    
    var image: UIImage?
    
    // MARK: - Computed Properties
    var name: String { filename.undotted.spaced.capitalized }
    
    // MARK: - Initializers
    init?(named path: String) {
        guard let url = Bundle.main.url(forResource: "Assets.scnassets/\(path)", withExtension: nil) else { return nil }
        
        filename = NSString(string: path).lastPathComponent
        self.url = url
        
        // try to find an image with the same name
        if let image = UIImage(named: filename.undotted) {
            self.image = image
            return
        }
        
        let size = CGSize(width: 96, height: 128)
        let scale = UIScreen.main.scale
        
        // create the thumbnail request
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .icon
        )
        
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { thumbnail, type, error in
            guard let thumbnail = thumbnail else {
                if let error = error {
                    print(#line, #function, error.localizedDescription)
                } else {
                    print(#line, #function, "ERROR: Can't create thumbnail for \(path)")
                }
                return
            }
            
            self.image = thumbnail.uiImage
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.imageUpdatedNotification, object: self)
            }
        }
    }
}

// MARK: - Comparable
extension USDZModel: Comparable {
    static func < (lhs: USDZModel, rhs: USDZModel) -> Bool { lhs.name < rhs.name }
    static func == (lhs: USDZModel, rhs: USDZModel) -> Bool { lhs.name == rhs.name }
}

// MARK: - CustomStringConvertible
extension USDZModel: CustomStringConvertible {
    var description: String {
        return "\(name): \(image?.description ?? "no thumbnail")"
    }
}
