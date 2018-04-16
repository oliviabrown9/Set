//
//  Set.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation

struct SetGame {
    
    private(set) var cards = [Card]()
    private(set) var selectedCards = [Card]()
    private(set) var score = 0
    
    mutating func selectCard(card: Card) {
        
//        if selectedCards.count == 3 && isSet() {
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
    
//    private func setFound() -> Bool {
//        //If two are... and one is not, then it is not a 'Set'.
//        if selectedCards.count != 3 {
//            return false
//        }
//
//        if selectedCards[0].cardColor == selectedCards[1].cardColor {
//            if selectedCards[0].cardColor != selectedCards[2].cardColor {
//                return false
//            }
//        } else if selectedCards[1].cardColor == selectedCards[2].cardColor {
//            return false
//        } else if (selectedCards[0].cardColor == selectedCards[2].cardColor) {
//            return false
//        }
//
//        if selectedCards[0].cardNumber == selectedCards[1].cardNumber {
//            if selectedCards[0].cardNumber != selectedCards[2].cardNumber {
//                return false
//            }
//        } else if selectedCards[1].cardNumber == selectedCards[2].cardNumber {
//            return false
//        } else if (selectedCards[0].cardNumber == selectedCards[2].cardNumber) {
//            return false
//        }
//
//        if selectedCards[0].cardShading == selectedCards[1].cardShading {
//            if selectedCards[0].cardShading != selectedCards[2].cardShading {
//                return false
//            }
//        } else if selectedCards[1].cardShading == selectedCards[2].cardShading {
//            return false
//        } else if (selectedCards[0].cardShading == selectedCards[2].cardShading) {
//            return false
//        }
//
//        if selectedCards[0].cardSymbol == selectedCards[1].cardSymbol {
//            if selectedCards[0].cardSymbol != selectedCards[2].cardSymbol {
//                return false
//            }
//        } else if selectedCards[1].cardSymbol == selectedCards[2].cardSymbol {
//            return false
//        } else if (selectedCards[0].cardSymbol == selectedCards[2].cardSymbol) {
//            return false
//        }
//
//        return true
//    }
}

