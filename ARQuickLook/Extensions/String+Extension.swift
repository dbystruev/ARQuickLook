//
//  String+Extension.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 03.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

extension String {
    var spaced: String { replacingOccurrences(of: "_", with: " ") }
    
    var undotted: String {
        var result = ""
        for letter in self {
            if letter == "." { break }
            result = "\(result)\(letter)"
        }
        return result
    }
}
