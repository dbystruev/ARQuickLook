//
//  ViewController.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 02.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Computed Properties
    var usdzModelNames: [String] {
        guard let resourceURL = Bundle.main.resourceURL else { return [] }
        let usdzPath = resourceURL.appendingPathComponent("Assets.scnassets").path
        
        guard let usdzFiles = try? FileManager.default.contentsOfDirectory(atPath: usdzPath) else { return [] }
        
        return usdzFiles.filter { $0.hasSuffix(".usdz") }
    }
    
    // MARK: - Stored Properties
    var usdzModels = [USDZModel]()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fill USDZ Models array with actual models data
        usdzModelNames.forEach { name in
            let fullName = "Assets.scnassets/\(name)"
            usdzModels.append(USDZModel(named: fullName))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print(#line, #function, self.usdzModels)
        }
    }
    
}
