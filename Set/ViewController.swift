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
            if cardNumber < game.cards.count {
//                game.select(card: setGame.cardsInGame[cardIndex])
        }
        updateViewFromModel()
            }
        
        }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateViewFromModel() {
        
    }

}

