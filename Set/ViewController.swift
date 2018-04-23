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
    @IBOutlet weak var cardsView: UIView! {
        didSet {
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(game.shuffleCardsInGame))
            cardsView.addGestureRecognizer(rotateGesture)
        }
    }
    
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
    }
    
    // Selects a card in game if possible
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender) {
            if index < game.currentCardsInGame.count {
                game.selectCard(card: game.currentCardsInGame[index])
            }
            updateViewFromModel()
        }
    }
    
    // Loads an initial game on start
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    // Resets the design of the buttons
    private func clearButtons() {
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            button.removeOutline()
            button.backgroundColor = UIColor.clear
            button.setAttributedTitle(nil, for: UIControlState.normal)
        }
    }
    
    // Creates the UI of the game based on the Attribute enums for all the current cards in game
    private func updateViewFromModel() {
        clearButtons()
        var cardIndex = 0
        for card in game.currentCardsInGame {
            let cardView = CardView()
            
            var cardTitle, symbol: String
            var titleAttributes: [NSAttributedStringKey: Any] = [:]
            var titleColor: UIColor
//
//            cardButton.setAttributedTitle(NSAttributedString(string: cardTitle, attributes: titleAttributes), for: .normal)
//            cardIndex += 1
//
//            // Outlines the selected cards and changes color if a set is correct/incorrect
//            if game.selectedCards.contains(card) {
//                if game.setFound(withCards: game.selectedCards) {
//                    cardButton.outline(inColor: UIColor.green)
//                }
//                else if game.selectedCards.count == 3 {
//                    cardButton.outline(inColor: UIColor.red)
//                }
//                else {
//                    cardButton.outline(inColor: UIColor.black)
//                }
//            }
//            else {
//                cardButton.removeOutline()
//            }
        }
        
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

