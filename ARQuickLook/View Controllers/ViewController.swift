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
    
    // MARK: - Managers
    let cellManager = CellManager()
    
    // MARK: - Computed Properties
    var usdzModelNames: [String] {
        guard let resourceURL = Bundle.main.resourceURL else { return [] }
        let usdzPath = resourceURL.appendingPathComponent("Assets.scnassets").path
        
        guard let usdzFiles = try? FileManager.default.contentsOfDirectory(atPath: usdzPath) else { return [] }
        
        return usdzFiles.filter { $0.hasSuffix(".usdz") }
    }
    
    // MARK: - Stored Properties
    var usdzModels = [USDZModel]()
    
    // MARK: - Custom Methods
    @objc func imageUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // Update tableView when images are updated
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imageUpdated),
            name: USDZModel.imageUpdatedNotification,
            object: nil
        )
        
        // Fill USDZ Models array with actual models data
        usdzModelNames.forEach { name in
            let fullName = "Assets.scnassets/\(name)"
            usdzModels.append(USDZModel(named: fullName))
        }
        usdzModels.sort()
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "USDZCell", for: indexPath)
        let usdzModel = usdzModels[indexPath.row]
        
        cellManager.configure(cell, with: usdzModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usdzModels.count
    }
}
