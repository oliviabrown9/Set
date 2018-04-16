//
//  Card.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let cardColor: MatchVariant
    let cardSymbol: MatchVariant
    let cardNumber: MatchVariant
    let cardShading: MatchVariant
    
//    init(color: MatchVariant, symbol: MatchVariant, number: MatchVariant, shading: MatchVariant) {
//        cardColor = color
//        cardSymbol = symbol
//        cardNumber = number
//        cardShading = shading
//    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.cardNumber == rhs.cardNumber && lhs.cardSymbol == rhs.cardSymbol && lhs.cardShading == rhs.cardShading && lhs.cardColor == rhs.cardColor
    }

    enum MatchVariant {
        case A, B, C
        
        static var all: [MatchVariant] {
            return [.A, .B, .C]
        }
    }
}
