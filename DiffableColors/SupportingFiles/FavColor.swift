//
//  FavColor.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import Foundation

struct FavColor: Hashable, Codable {
    
    var color: Color.Values
    var name: String?
    var id = UUID().uuidString
    var timeStamp = Date().timeIntervalSinceReferenceDate

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FavColor, rhs: FavColor) -> Bool {
        lhs.color == rhs.color && lhs.name == rhs.name
    }
    
    init(color: Color.Values, name: String?) {
        self.color = color
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try values.decode(Color.Values.self, forKey: .color)
        self.name = try values.decode(Optional<String>.self, forKey: .name)
        self.id = try values.decode(String.self, forKey: .id)
        self.timeStamp = try values.decode(TimeInterval.self, forKey: .timeStamp)
    }
    
}
