//
//  ViewController.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private(set) var game = SetGame()
    @IBOutlet weak var cardsView: CardsInGameView! {
        didSet {
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(game.shuffleCardsInGame))
            cardsView.addGestureRecognizer(rotateGesture)
        }
    }
    
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
    }
    
    // Selects a card in game if possible
//    @IBAction private func touchCard(_ sender: UIButton) {
//        if let index = cardButtons.index(of: sender) {
//            if index < game.currentCardsInGame.count {
//                game.selectCard(card: game.currentCardsInGame[index])
//            }
//            updateViewFromModel()
//        }
//    }
    
    // Loads an initial game on start
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    // Creates the UI of the game based on the Attribute enums for all the current cards in game
    private func updateViewFromModel() {
        
        cardsView.game = game
        
        
//        for card in game.currentCardsInGame {
//            let cardView = CardView()
//            cardView.associatedCard = card
//
//            // Outlines the selected cards and changes color if a set is correct/incorrect
//            if game.selectedCards.contains(card) {
//                if game.setFound(withCards: game.selectedCards) {
//                    cardView.layer.borderColor = UIColor.green.cgColor
//                    cardView.layer.borderWidth = 3.0
//                }
//                else if game.selectedCards.count == 3 {
//                    cardView.layer.borderColor = UIColor.red.cgColor
//                    cardView.layer.borderWidth = 3.0
//                }
//                else {
//                    cardView.layer.borderColor = UIColor.black.cgColor
//                    cardView.layer.borderWidth = 3.0
//                }
//            }
//            else {
//                cardView.layer.borderColor = UIColor.clear.cgColor
//                cardView.layer.borderWidth = 0.0
//            }
//        }
        
        // Update the ability to deal three more cards & update score label
        if game.deck.cards.isEmpty {
            dealThreeCardsButton.isEnabled = false
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

