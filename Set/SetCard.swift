//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct SetCard: Hashable {
    
    let color: Attribute
    let symbol: Attribute
    let number: Attribute
    let shading: Attribute
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
    var hashValue: Int {
        return (color.rawValue * 2) + (symbol.rawValue * 3) + (number.rawValue * 4) + (shading.rawValue * 5)
    }
    
    enum Attribute: Int {
        case A, B, C
        static var cases: [Attribute] {
            return [.A, .B, .C]
        }
    }
}
