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
    
    // Loads an initial game on start
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        
        cardsView.game = game
    
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

