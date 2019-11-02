//
//  ViewController.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 02.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import QuickLookThumbnailing
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var usdzModels: [String] {
        guard let resourceURL = Bundle.main.resourceURL else { return [] }
        
        let usdzPath = resourceURL.appendingPathComponent("Assets.scnassets").path
        
        guard let usdzFiles = try? FileManager.default.contentsOfDirectory(atPath: usdzPath) else {
            return []
        }
        
        return usdzFiles.filter { $0.hasSuffix(".usdz") }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#line, #function, usdzModels)
    }
    
}
