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
    private(set) var selectedCards = [Card]()
    private(set) var score = 0
    
    mutating func selectCard(card: Card) {
        
        if selectedCards.count == 3 && setFound() {
//            selectedCards.forEach {
//                if let selectedCardInGameIndex = cardsInGame.index(of: $0) {
//                    cardsInGame.remove(at: selectedCardInGameIndex)
//                    if availableCards.count > 0 {
//                        let selectedCard = availableCards.remove(at: availableCards.count.arc4Random())
//                        cardsInGame.insert(selectedCard, at: selectedCardInGameIndex)
//                    }
//                }
//            }
//            selectedCards.removeAll()
//            score += 3
//        }
//        else if selectedCards.count == 3 && !isSet() {
//            selectedCards.removeAll()
//            score -= 1
//        }
//
//        if let alreadySelectedCardIndex = selectedCards.index(of: card) {
//            selectedCards.remove(at: alreadySelectedCardIndex)
//        }
//        else {
//            selectedCards.append(card)
//        }
        
//        print("Selected \(selectedCards.count) cards")
//        print("Cards available in deck \(availableCards.count) cards")
//        print("Cards in game \(cardsInGame.count) cards")
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

