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
    var cancellables = Cancellables()
    
    // MARK: Assign The Diffable DataSource
    lazy var dataSource = { UITableViewDiffableDataSource<DefaultSection, FavColor>(
        tableView: colorFavsList,
        cellProvider: colorFavCell)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorFavsList.delegate = self
        
        // MARK: Apply the initial Snapshot
        dataSource.apply(colorFavSnapshot(AppMemory.shared.favColors), animatingDifferences: true)
        bindPublishers()
    }
    
    private var colorFavSnapshot: ([FavColor]) -> NSDiffableDataSourceSnapshot<DefaultSection, FavColor> {
        return { newColors in
            var snapshot = NSDiffableDataSourceSnapshot<DefaultSection, FavColor>()
            snapshot.appendSections([.main])
            snapshot.appendItems(newColors)
            return snapshot
        }
    }
    
    // MARK: Create a Cell Provider
    private var colorFavCell: (UITableView, IndexPath, FavColor) -> UITableViewCell? {
        return { [weak self] tableView, indexPath, favColor in
            guard
                let self = self,
                let cFavCell = Bundle.main.loadNibNamed(ColorFavCell.sbid,
                                                        owner: self,
                                                        options: nil
                    )?.first as? ColorFavCell
                else { return nil }
            
            cFavCell.colorView.shiftTo(favColor.color)
            cFavCell.nameLabel.text = favColor.name
            cFavCell.hexLabel.text = favColor.color.hex
            return cFavCell
        }
    }
    
    // MARK: Persistence Actions / Snapshot updates
    private var saveAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let snapshot = self.colorFavSnapshot($0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private var editAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let snapshot = self.colorFavSnapshot($0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private var deleteAction: ([FavColor]) -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let snapshot = self.colorFavSnapshot($0)
            self.dataSource.apply(snapshot, animatingDifferences: true)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let color = dataSource.itemIdentifier(for: indexPath) else { return }
        ColorEditController.activate(from: self, setToColor: color)
    }

}


// MARK: TableView Sections
enum DefaultSection { case main }
