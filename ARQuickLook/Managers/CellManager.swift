//
//  CellManager.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 02.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CellManager {
    func configure(_ cell: UITableViewCell, with model: USDZModel) {
        guard let usdzCell = cell as? USDZCell else { return }
        
        DispatchQueue.main.async {
            usdzCell.nameLabel.text = model.name
            usdzCell.previewImageView.image = model.image
        }
    }
}
