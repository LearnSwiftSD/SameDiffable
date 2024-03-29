//
//  ColorFavsController.swift
//  ColorFav
//
//  Created by Stephen Martinez on 7/16/18.
//  Copyright © 2018 Stephen Martinez. All rights reserved.
//

import UIKit
import Combine

class ColorFavsController: UIViewController {
    
    @IBOutlet weak var colorFavsList: UITableView!
    var selectedPath = IndexPath(row: 0, section: 0)
    var colorList = [FavColor]()
    var cancellables = Cancellables()
    
    // MARK: Assign/Create The Diffable DataSource `dataSource`
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Apply the initial Snapshot
        colorList = AppMemory.shared.favColors
        colorFavsList.delegate = self
        colorFavsList.dataSource = self
        bindPublishers()
        
    }
    
    // MARK: Create a snapshot provider `colorFavSnapshot`
    
    // MARK: Create a Cell Provider `colorFavCell`
    
    // MARK: - Persistence Actions / update with Snapshot updates
    private var saveAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.colorList = $0
            let path = [IndexPath(row: 0, section: 0)]
            self.colorFavsList.insertRows(at: path, with: .left)
        }
    }
    
    private var editAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.colorList = $0
            self.colorFavsList.reloadRows(at: [self.selectedPath], with: .fade)
        }
    }
    
    private var deleteAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            self.colorList = $0
            self.colorFavsList.deleteRows(at: [self.selectedPath], with: .right)
        }
    }
    
    
    func bindPublishers() {
        AppMemory.shared.didSave
            .print("DidSave")
            .supply(to: saveAction)
            .store(in: &cancellables)
        
        AppMemory.shared.didUpdate
            .print("DidDelete")
            .supply(to: editAction)
            .store(in: &cancellables)
        
        AppMemory.shared.didDelete
            .print("DidDelete")
            .supply(to: deleteAction)
            .store(in: &cancellables)
    }
    
    @IBAction func createFavColor(_ sender: Any) {
        ColorSaveController.activate(from: self)
    }
    
}

// MARK: - TableView Methods
extension ColorFavsController: UITableViewDelegate {

    // MARK: Update with new DiffableDataSource API
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPath = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        ColorEditController.activate(from: self, setToColor: colorList[indexPath.row])
    }

}

extension ColorFavsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let colorFavCell =
            Bundle.main.loadNibNamed(ColorFavCell.sbid,owner: self, options: nil)?.first as? ColorFavCell else {
            return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        }
        colorFavCell.colorView.shiftTo(colorList[indexPath.row].color)
        colorFavCell.nameLabel.text = colorList[indexPath.row].name
        colorFavCell.hexLabel.text = colorList[indexPath.row].color.hex
        return colorFavCell
    }
    
}

// MARK: - Create DiffableDataSource TableView Sections
