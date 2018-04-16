//
//  Deck.swift
//  Set
//
//  Created by Olivia Brown on 4/16/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct Deck {
    
    private(set) var cards = [Card]()
    
    init() {
        for color in Card.MatchVariant.all {
            for symbol in Card.MatchVariant.all {
                for number in Card.MatchVariant.all {
                    for shading in Card.MatchVariant.all {
                        cards.append(Card(color: color, symbol: symbol, number: number, shading: shading))
                    }
                }
            }
        }
    }
    
    mutating func drawCard() -> Card {
        let cardDrawn = self.cards.remove(at: Int(arc4random_uniform(UInt32(self.cards.count))))
        return cardDrawn
    }
}
