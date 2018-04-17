//
//  ViewController.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var dealThreeCardsButton: UIButton!
    
    var game = SetGame()
    
    @IBAction func dealThreeCards(_ sender: UIButton) {
        game.addThreeCards()
        updateViewFromModel()
        if game.currentCardsInGame.count >= 24 {
            dealThreeCardsButton.isEnabled = false
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            if index < game.currentCardsInGame.count {
                game.selectCard(card: game.currentCardsInGame[index])
            }
            updateViewFromModel()
        }
    }
    
    func clearButtons() {
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            button.removeOutline()
            button.backgroundColor = UIColor.clear
            button.setAttributedTitle(nil, for: UIControlState.normal)
        }
    }
    
    private func updateViewFromModel() {
        
        var cardIndex = 0
        clearButtons()
        for card in game.currentCardsInGame {
            let cardButton = cardButtons[cardIndex]
            cardButton.backgroundColor = UIColor.white

            var cardTitle, symbol: String
            switch card.symbol {
            case .A:
                symbol = "▲"
            case .B:
                symbol = "●"
            case .C:
                symbol = "■"
            }
            
            switch card.number {
            case .A:
                cardTitle = symbol
            case .B:
                cardTitle = "\(symbol) \(symbol)"
            case .C:
                cardTitle = "\(symbol) \(symbol) \(symbol)"
            }
            
            var attributes: [NSAttributedStringKey: Any] = [:]
            var color: UIColor
            
            switch card.color {
            case .A:
                color = UIColor.orange
            case .B:
                color = UIColor.purple
            case .C:
                color = UIColor.blue
            }
            
            switch card.shading {
            case .A:
                attributes[.foregroundColor] = color
                attributes[.strokeWidth] = 3
            case .B:
                attributes[.foregroundColor] = color
                attributes[.strokeWidth] = -1
            case .C:
                attributes[.foregroundColor] = color.withAlphaComponent(0.15)
                attributes[.strokeWidth] = -1
            }

            cardButton.setAttributedTitle(NSAttributedString(string: cardTitle, attributes: attributes), for: .normal)
            cardIndex += 1
            
            if game.selectedCards.contains(card) {
                if game.setFound() {
                    cardButton.outline(inColor: UIColor.green)
                }
                else if game.selectedCards.count == 3 {
                    cardButton.outline(inColor: UIColor.red)
                }
                else {
                    cardButton.outline(inColor: UIColor.black)
                }
            }
            else {
                cardButton.removeOutline()
            }
        }
    }
}

extension UIButton {
    
    func outline(inColor color: UIColor) {
        self.layer.borderWidth = 5.0
        self.layer.borderColor = color.cgColor
    }
    
    func removeOutline() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}

