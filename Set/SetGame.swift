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
    private var firstMoveTime: Date?
    private var foundSet: [Card]?
    
    init() {
        newGame()
    }
    
    // Replace 3 cards if found match, add three cards if not
    mutating func addThreeCards() {
        if setFound(withCards: selectedCards) {
            replace(cards: selectedCards)
        }
        else {
            for _ in 0..<3 {
                currentCardsInGame.append(deck.drawCard())
            }
        }
    }
    
    // Locates the passed cards and inserts a new random card at that index
    private mutating func replace(cards: [Card]) {
        cards.forEach {
            if let cardIndex = currentCardsInGame.index(of: $0) {
                currentCardsInGame.remove(at: cardIndex)
                if !deck.cards.isEmpty {
                    currentCardsInGame.insert(deck.drawCard(), at: cardIndex)
                }
            }
        }
    }
    
    // Handles when a selection by checking if a set is found or if the card was already selected
    mutating func selectCard(card: Card) {
        if selectedCards.count == 3 && setFound(withCards: selectedCards) {
            replace(cards: selectedCards)
            selectedCards.removeAll()
            if let firstTime = firstMoveTime {
                score += (3 * Int(10.0/(abs(firstTime.timeIntervalSinceNow))))
            }
        }
        else if selectedCards.count == 3 && !setFound(withCards: selectedCards) {
            selectedCards.removeAll()
            score -= 5
        }
        
        if let alreadySelectedCardIndex = selectedCards.index(of: card) {
            selectedCards.remove(at: alreadySelectedCardIndex)
            score -= 1
        }
        else {
            selectedCards.append(card)
            if selectedCards.count == 1 {
                firstMoveTime = Date()
            }
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
    
    // Checks if a set was found based on Attribute enums of the card
    func setFound(withCards cards: [Card]) -> Bool {
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

