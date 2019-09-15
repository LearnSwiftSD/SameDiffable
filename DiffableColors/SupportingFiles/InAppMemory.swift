//
//  InAppMemory.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import Foundation
import Combine

class InAppMemory {
    
    private var storage = [String: FavColor]()
    
    let didSave = PassthroughSubject<[FavColor], Never>()
    let didUpdate = PassthroughSubject<[FavColor], Never>()
    let didDelete = PassthroughSubject<[FavColor], Never>()
    
    static let shared = InAppMemory()
    
    private init() { }
    
    var favColors: [FavColor] {
        get { storage
            .map { $0.value }
            .sorted(by: { $0.timeStamp > $1.timeStamp })
        }
    }
    
    func save(color: FavColor) {
        storage[color.id] = color
        didSave.send(favColors)
    }
    
    func update(color: FavColor) {
        storage[color.id] = color
        didUpdate.send(favColors)
    }
    
    func delete(color: FavColor) {
        storage[color.id] = nil
        didDelete.send(favColors)
    }
    
}
