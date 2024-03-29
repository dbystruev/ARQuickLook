//
//  ViewController.swift
//  ARQuickLook
//
//  Created by Denis Bystruev on 02.11.2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import ARKit
import QuickLook
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
        
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        // Update tableView when images are updated
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imageUpdated),
            name: USDZModel.imageUpdatedNotification,
            object: nil
        )
        
        // Fill USDZ Models array with actual models data
        usdzModels = usdzModelNames.compactMap({ USDZModel(named: $0) }).sorted()
    }
    
}

// MARK: - QLPreviewControllerDataSource
extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let indexPath = tableView.indexPathForSelectedRow ?? tableView.indexPathsForVisibleRows?.first ?? IndexPath()
        let usdzModel = usdzModels[indexPath.row]
        if #available(iOS 13.0, *) {
            return ARQuickLookPreviewItem(fileAt: usdzModel.url)
        } else {
            let item = usdzModel.url as QLPreviewItem
            return item
        }
    }
}

// MARK: - QLPreviewControllerDelegate
extension ViewController: QLPreviewControllerDelegate {
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        guard let cell = tableView.cellForRow(at: indexPath) as? USDZCell else { return nil }
        return cell.previewImageView
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { usdzModels.count }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Rotate the cell
        let cell = tableView.cellForRow(at: indexPath) as? USDZCell
        
        if #available(iOS 13.0, *) {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
                cell?.previewImageView.transform3D = CATransform3DMakeRotation(.pi, 0, 1, 0)
            })
        }
        
        // Prepare the quick look controller
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        
        // Present quick look modally
        present(previewController, animated: true) {
            // Cancel cell rotation
            if #available(iOS 13.0, *) {
                UIView.modifyAnimations(withRepeatCount: 0, autoreverses: false) {
                    cell?.previewImageView.transform3D = CATransform3DIdentity
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
