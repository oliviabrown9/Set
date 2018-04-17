//
//  ViewController.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var dealThreeCardsButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.newGame()
        updateViewFromModel()
        dealThreeCardsButton.isEnabled = true
    }
    
    @IBAction private func dealThreeCards(_ sender: UIButton) {
        game.addThreeCards()
        updateViewFromModel()
        if game.currentCardsInGame.count >= 24 {
            dealThreeCardsButton.isEnabled = false
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            if index < game.currentCardsInGame.count {
                game.selectCard(card: game.currentCardsInGame[index])
            }
            updateViewFromModel()
            if game.deck.cards.isEmpty {
                dealThreeCardsButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func clearButtons() {
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            button.removeOutline()
            button.backgroundColor = UIColor.clear
            button.setAttributedTitle(nil, for: UIControlState.normal)
        }
    }
    
    private func updateViewFromModel() {
        clearButtons()
        
        var cardIndex = 0
        
        for card in game.currentCardsInGame {
            let cardButton = cardButtons[cardIndex]
            cardButton.backgroundColor = UIColor.white

            var cardTitle, symbol: String
            var titleAttributes: [NSAttributedStringKey: Any] = [:]
            var titleColor: UIColor
            
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
            
            switch card.color {
            case .A:
                titleColor = UIColor.orange
            case .B:
                titleColor = UIColor.purple
            case .C:
                titleColor = UIColor.blue
            }
            
            switch card.shading {
            case .A:
                titleAttributes[.foregroundColor] = titleColor
                titleAttributes[.strokeWidth] = 3
            case .B:
                titleAttributes[.foregroundColor] = titleColor
                titleAttributes[.strokeWidth] = -1
            case .C:
                titleAttributes[.foregroundColor] = titleColor.withAlphaComponent(0.15)
                titleAttributes[.strokeWidth] = -1
            }

            cardButton.setAttributedTitle(NSAttributedString(string: cardTitle, attributes: titleAttributes), for: .normal)
            cardIndex += 1
            
            if game.selectedCards.contains(card) {
                if game.setFound(withCards: game.selectedCards) {
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
        scoreLabel.text = "Score: \(game.score)"
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

