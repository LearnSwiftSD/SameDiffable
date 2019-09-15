//
//  FavColor.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import Foundation

struct FavColor: Hashable {
    
    var color: Color.Values
    var name: String?
    let id = UUID().uuidString
    var timeStamp = Date().timeIntervalSinceReferenceDate

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FavColor, rhs: FavColor) -> Bool {
        lhs.color == rhs.color && lhs.name == rhs.name
    }
    
}
