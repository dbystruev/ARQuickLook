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
    // MARK: - Stored Properties
    private let name: String
    var image: UIImage?
    
    // MARK: - Initializers
    init(named name: String) {
        self.name = NSString(string: name).lastPathComponent
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return }
        
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
                    print(#line, #function, "ERROR: Can't create thumbnail for \(name)")
                }
                return
            }
            
            self.image = thumbnail.uiImage
        }
    }
}

extension USDZModel: CustomStringConvertible {
    var description: String {
        return "\(name): \(image?.description ?? "no thumbnail")"
    }
}
