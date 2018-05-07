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
    
    var deckView: CardView?
    var discardPileView: CardView?
    var cardViews = [Card: CardView]()
    
    @IBOutlet private weak var cardsView: UIView! {
        didSet {
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(sender:)))
            cardsView.addGestureRecognizer(rotateGesture)
            
            let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(sender:)))
            swipeDownGesture.direction = .down
            swipeDownGesture.numberOfTouchesRequired = 1
            cardsView.addGestureRecognizer(swipeDownGesture)
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    @objc private func handleRotate(sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.shuffleCardsInGame()
            updateViewFromModel()
        }
    }
    
    @objc private func handleSwipeDown(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.addThreeCards()
            updateViewFromModel()
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let selectedCardView = sender.view else {
                return
            }
            if let cardIndex = cardsView.subviews.index(of: selectedCardView) {
                game.selectCard(card: game.currentCardsInGame[cardIndex])
                updateViewFromModel()
            }
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
    
    private let cardAspectRatio: CGFloat = 5/8
    
    private func updateViewFromModel() {
        var cardGrid = Grid(layout: .aspectRatio(cardAspectRatio), frame: cardsView.bounds)
        cardGrid.cellCount = game.currentCardsInGame.count
        
        var currentCardViews = [CardView]()
        
        for cardIndex in game.currentCardsInGame.indices {
            let cardView = CardView()
            setCardViewAttributes(fromCard: game.currentCardsInGame[cardIndex], forView: cardView)
            addOutline(to: cardView, withCard: game.currentCardsInGame[cardIndex])
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            cardView.addGestureRecognizer(tap)
            currentCardViews.append(cardView)
            
            if let cell = cardGrid[cardIndex] {
                if !cardsView.subviews.contains(cardView) {
                    cardsView.addSubview(cardView)
                    cardView.frame.origin = dealThreeCardsButton.frame.origin
                }
                if cardView.frame.origin == dealThreeCardsButton.frame.origin {
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.8,
                        delay: 1.5,
                        options: [.curveEaseInOut],
                        animations: {
                            cardView.frame = cell
                    }, completion: { finished in
                        UIView.transition(
                            with: cardView,
                            duration: 0.5,
                            options: [.transitionFlipFromLeft],
                            animations: {
                                cardView.isFaceUp = true
                        })
                    })
                }
            }
        }
        
        // Update the ability to deal three more cards & update score label
//        if game.deck.cards.isEmpty {
//            dealThreeCardsButton.isEnabled = false
//        }
//        scoreLabel.text = "Score: \(game.score)"
    }
    
    
    private func addOutline(to cardView: CardView, withCard card: Card) {
        // Outlines the selected cards and changes color if a set is correct/incorrect
        if game.selectedCards.contains(card) {
            cardView.layer.borderWidth = 5.0
            if game.setFound(withCards: game.selectedCards) {
                cardView.layer.borderColor = UIColor.green.cgColor
            }
            else if game.selectedCards.count == 3 {
                cardView.layer.borderColor = UIColor.red.cgColor
            }
            else {
                cardView.layer.borderColor = UIColor.black.cgColor
            }
        }
        else {
            cardView.layer.borderWidth = 0.0
        }
    }
    
    private func setCardViewAttributes(fromCard card: Card, forView view: CardView) {
        switch card.color {
        case .A : view.color = .A
        case .B : view.color = .B
        case .C : view.color = .C
        }
        switch card.number {
        case .A : view.number = .A
        case .B : view.number = .B
        case .C : view.number = .C
        }
        switch card.shading {
        case .A : view.shading = .A
        case .B : view.shading = .B
        case .C : view.shading = .C
        }
        switch card.symbol {
        case .A : view.symbol = .A
        case .B : view.symbol = .B
        case .C : view.symbol = .C
        }
    }
}
