//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let color: Attribute
    let symbol: Attribute
    let number: Attribute
    let shading: Attribute
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }

    enum Attribute {
        case A, B, C
        static var cases: [Attribute] {
            return [.A, .B, .C]
        }
    }
}
