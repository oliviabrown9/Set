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
        newGame()
    }
    
    mutating func addThreeCards() {
        if setFound() {
            replace(cards: selectedCards)
        }
        else {
            for _ in 0..<3 {
                currentCardsInGame.append(deck.drawCard())
            }
        }
    }
    
    mutating func replace(cards: [Card]) {
        cards.forEach {
            if let cardIndex = currentCardsInGame.index(of: $0) {
                currentCardsInGame.remove(at: cardIndex)
                if !deck.cards.isEmpty {
                    currentCardsInGame.insert(deck.drawCard(), at: cardIndex)
                }
            }
        }
    }
    
    mutating func selectCard(card: Card) {
        if selectedCards.count == 3 && setFound() {
            replace(cards: selectedCards)
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
    
    mutating func newGame() {
        score = 0
        currentCardsInGame.removeAll()
        selectedCards.removeAll()
        deck.fillDeck()
        
        for _ in 0..<12 {
            currentCardsInGame.append(deck.drawCard())
        }
    }

    
    func setFound() -> Bool {
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

