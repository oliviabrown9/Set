//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let color: MatchVariant
    let symbol: MatchVariant
    let number: MatchVariant
    let shading: MatchVariant
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }

    enum MatchVariant {
        case A, B, C
        
        static var all: [MatchVariant] {
            return [.A, .B, .C]
        }
    }
}
