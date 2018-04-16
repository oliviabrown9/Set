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
        
        var cardString: NSMutableAttributedString
        
        for card in game.currentCardsInGame {
            switch card.symbol {
            case .A:
                print("card button should be symbol A")
            case .B:
                print("card button should be symbol B")
            case .C:
                print("card button should be symbol C")
            }
            
            switch card.number {
            case .A:
                print("card button should be number A")
            case .B:
                print("card button should be number B")
            case .C:
                print("card button should be number C")
            }
            
            switch card.color {
            case .A:
                print("card button should be color A")
            case .B:
                print("card button should be color B")
            case .C:
                print("card button should be color C")
            }
            
            switch card.shading {
            case .A:
                print("card button should be shading A")
            case .B:
                print("card button should be shading B")
            case .C:
                print("card button should be shading C")
            }
        }
    }
}

