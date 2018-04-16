//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    
    enum Number {
        case one
        case two
        case three
    }
    
    enum Symbol {
        case one
        case two
        case three
    }
    
    enum Shading {
        case one
        case two
        case three
    }
    
    enum Color {
        case one
        case two
        case three
    }
}
