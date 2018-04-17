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
    
    mutating func addThreeCards() {
        if setFound(withCards: selectedCards) {
            replace(cards: selectedCards)
        }
        else {
            for _ in 0..<3 {
                currentCardsInGame.append(deck.drawCard())
            }
            if isSetAvailable() {
                score -= 5
            }
        }
    }
    
    mutating func cheat() {
        if isSetAvailable() {
            if let set = foundSet {
                selectedCards = set
            }
        }
    }
    
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
    
    mutating func selectCard(card: Card) {
        if selectedCards.count == 3 && setFound(withCards: selectedCards) {
            replace(cards: selectedCards)
            selectedCards.removeAll()
            if let firstTime = firstMoveTime {
                score += (3 * Int(1.0/(abs(firstTime.timeIntervalSinceNow))))
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
    
    mutating func isSetAvailable() -> Bool {
            for firstCardIndex in currentCardsInGame.indices{
                for secondCardIndex in (firstCardIndex+1)..<currentCardsInGame.count{
                    for thirdCardIndex in (secondCardIndex+1)..<currentCardsInGame.count{
                        if setFound(withCards: [currentCardsInGame[firstCardIndex], currentCardsInGame[secondCardIndex], currentCardsInGame[thirdCardIndex]]) == true {
                            foundSet = [
                                currentCardsInGame[firstCardIndex],
                                currentCardsInGame[secondCardIndex],
                                currentCardsInGame[thirdCardIndex]
                            ]
                            return true
                            }
                        }
                    }
                }
        return false
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

