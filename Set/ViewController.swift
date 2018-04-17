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
    
    let game = SetGame()
    
    @IBAction func dealThreeCards(_ sender: UIButton) {
        
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        //    if card.isSelected {
        //        button.layer.borderWidth = 3.0
        //        button.layer.borderColor = UIColor.blue.cgColor
        //    }
        if let cardNumber = cardButtons.index(of: sender) {
            if cardNumber < game.deck.cards.count {
//                game.select(card: setGame.cardsInGame[cardIndex])
            }
            updateViewFromModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func updateViewFromModel() {
        
        var cardIndex = 0
        
        for card in game.currentCardsInGame {
            let cardButton = cardButtons[cardIndex]

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
                color = UIColor.yellow
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
        }
    }
}

