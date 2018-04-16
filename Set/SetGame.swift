//
//  Set.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var deck = Deck()
    private(set) var currentCardsInGame = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var score = 0
    
    init() {
        for _ in 1..<12 {
            currentCardsInGame.append(deck.drawCard())
        }
    }
    
    mutating func selectCard(card: Card) {
        if selectedCards.count == 3 && setFound() {
            for card in selectedCards {
                currentCardsInGame = currentCardsInGame.filter() { $0 != card }
            }
            if !deck.cards.isEmpty {
                currentCardsInGame.append(deck.drawCard())
            }
            selectedCards.removeAll()
            score += 3
        }
        else if selectedCards.count == 3 && !setFound() {
            selectedCards.removeAll()
            score -= 1
        }
        
        if let alreadySelectedCardIndex = selectedCards.index(of: card) {
            selectedCards.remove(at: alreadySelectedCardIndex)
        }
        else {
            selectedCards.append(card)
        }
    }
    
    private func setFound() -> Bool {
        if selectedCards.count == 3 {
            if selectedCards[0].color == selectedCards[1].color && selectedCards[0].color == selectedCards[2].color ||
                selectedCards[0].color != selectedCards[1].color && selectedCards[0].color != selectedCards[2].color && selectedCards[1].color != selectedCards[2].color {

                if selectedCards[0].number == selectedCards[1].number && selectedCards[0].number == selectedCards[2].number ||
                    selectedCards[0].number != selectedCards[1].number && selectedCards[0].number != selectedCards[2].number && selectedCards[1].number != selectedCards[2].number {
                    
                    if selectedCards[0].shading == selectedCards[1].shading && selectedCards[0].shading == selectedCards[2].shading ||
                        selectedCards[0].shading != selectedCards[1].shading && selectedCards[0].shading != selectedCards[2].shading && selectedCards[1].shading != selectedCards[2].shading {
                        
                        if selectedCards[0].symbol == selectedCards[1].symbol && selectedCards[0].symbol == selectedCards[2].symbol ||
                            selectedCards[0].symbol != selectedCards[1].symbol && selectedCards[0].symbol != selectedCards[2].symbol && selectedCards[1].symbol != selectedCards[2].symbol {
                            
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}

