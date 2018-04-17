//
//  Deck.swift
//  Set
//
//  Created by Olivia Brown on 4/16/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

class Deck {
    
    private(set) var cards = [Card]()
    
    func fillDeck() {
        cards.removeAll()
        for color in Card.Attribute.cases {
            for symbol in Card.Attribute.cases {
                for number in Card.Attribute.cases {
                    for shading in Card.Attribute.cases {
                        cards.append(Card(color: color, symbol: symbol, number: number, shading: shading))
                    }
                }
            }
        }
    }
    
    func drawCard() -> Card {
        let cardDrawn = self.cards.remove(at: Int(arc4random_uniform(UInt32(self.cards.count))))
        return cardDrawn
    }
}
