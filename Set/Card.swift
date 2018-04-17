//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let color: CardOption
    let symbol: CardOption
    let number: CardOption
    let shading: CardOption
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.symbol == rhs.symbol && lhs.shading == rhs.shading && lhs.color == rhs.color
    }

    enum CardOption {
        case A, B, C
        static var cases: [CardOption] {
            return [.A, .B, .C]
        }
    }
}
