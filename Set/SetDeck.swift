//
//  Deck.swift
//  Set
//
//  Created by Olivia Brown on 4/16/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct SetDeck {
    
    private(set) var cards = [SetCard]()
    
    // Generates a deck with all possible combinations of Attribute enums
    mutating func fillDeck() {
        cards.removeAll()
        for color in SetCard.Attribute.cases {
            for symbol in SetCard.Attribute.cases {
                for number in SetCard.Attribute.cases {
                    for shading in SetCard.Attribute.cases {
                        cards.append(SetCard(color: color, symbol: symbol, number: number, shading: shading))
                    }
                }
            }
        }
    }
    
    // Removes and returns a random card from the deck
    mutating func drawCard() -> SetCard {
        let cardDrawn = self.cards.remove(at: Int(arc4random_uniform(UInt32(self.cards.count))))
        return cardDrawn
    }
}
