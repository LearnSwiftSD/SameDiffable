//
//  AppMemory.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import Foundation
import Combine

class AppMemory {
    
    private var storage: [String: FavColor]
    
    let didSave = PassthroughSubject<[FavColor], Never>()
    let didUpdate = PassthroughSubject<[FavColor], Never>()
    let didDelete = PassthroughSubject<[FavColor], Never>()
    
    static let shared = AppMemory()
    
    private init() {
        self.storage = AppMemory.storageContainer()
    }
    
    var favColors: [FavColor] {
        get { storage
            .map { $0.value }
            .sorted(by: { $0.timeStamp > $1.timeStamp })
        }
    }
    
    private static func storageContainer() -> [String: FavColor] {
        guard let data = UserDefaults.standard.data(forKey: "FavColors") else {
            updateContainer(with: [:])
            return [:]
        }
        let decoder = JSONDecoder()
        guard let container = try? decoder.decode([String: FavColor].self, from: data) else {
            print("Error decoding the container")
            return [:]
        }
        return container
    }
    
    private static func updateContainer(with favs: [String: FavColor]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(favs) else { print("Error encoding"); return }
        UserDefaults.standard.set(data, forKey: "FavColors")
    }
    
    func save(color: FavColor) {
        var newStorage = storage
        newStorage[color.id] = color
        AppMemory.updateContainer(with: newStorage)
        storage = newStorage
        didSave.send(favColors)
    }
    
    func update(color: FavColor) {
        var newStorage = storage
        newStorage[color.id] = color
        AppMemory.updateContainer(with: newStorage)
        storage = newStorage
        didUpdate.send(favColors)
    }
    
    func delete(color: FavColor) {
        var newStorage = storage
        newStorage[color.id] = nil
        AppMemory.updateContainer(with: newStorage)
        storage = newStorage
        didDelete.send(favColors)
    }
    
}
