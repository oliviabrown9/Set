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
    var discardView: CardView?
    var cardViewDict = [Card: CardView]()
    private weak var timer: Timer?
    
    
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
    lazy var animator = UIDynamicAnimator(referenceView: cardsView)
    
    let bottomViewToBoundsHeightRatio: CGFloat = 0.11
    let sideViewToBoundsWidthRatio: CGFloat = 0.14
    
    var deckConstants: DeckSizeConstants {
        if cardsView.bounds.height > cardsView.bounds.width {
            return DeckSizeConstants(forViewBounds:
                CGRect(
                    x: cardsView.bounds.origin.x,
                    y: cardsView.bounds.origin.y + cardsView.bounds.height * (1 - bottomViewToBoundsHeightRatio),
                    width: cardsView.bounds.width,
                    height: cardsView.bounds.height * bottomViewToBoundsHeightRatio))
        } else {
            return DeckSizeConstants(forViewBounds:
                CGRect(
                    x: cardsView.bounds.origin.x,
                    y: cardsView.bounds.origin.y,
                    width: cardsView.bounds.width * sideViewToBoundsWidthRatio,
                    height: cardsView.bounds.height))
        }
    }
    
    func findCardView(for card: Card) -> CardView {
        if cardViewDict[card] == nil {
            cardViewDict[card] = createCardView(for: card)
        }
        
        return cardViewDict[card]!
    }
    
    private func createCardView(for card: Card) -> CardView {
        let cardView = CardView()
        setCardViewAttributes(fromCard: card, forView: cardView)
        addOutline(to: cardView, withCard: card)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cardView.addGestureRecognizer(tap)
        
        cardView.frame = deckView?.frame ?? CGRect.zero
        
        return cardView
    }
    
    private func createDeckView() {
        if let currentDeckView = deckView {
            currentDeckView.removeFromSuperview()
            deckView = nil
        }
        if !game.deck.cards.isEmpty {
            deckView = CardView(frame: deckConstants.deckRect)
            cardsView.addSubview(deckView!)
        }
    }
    
    private func createDiscardView() {
        if let currentDiscardView = discardView {
            currentDiscardView.removeFromSuperview()
            discardView = CardView(frame: deckConstants.discardPileRect)
            cardsView.addSubview(discardView!)
        }
    }
    
    let drawingAnimationDuration: TimeInterval = 0.4
    let flippingAnimationDuration: TimeInterval = 0.5
    let freeFloatAnimationDuration: TimeInterval = 0.8
    let sendToDiscardPileAnimationDuration: TimeInterval = 0.2
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
        
        createDeckView()
        createDiscardView()
        
        var positionCardsAnimationDelay: TimeInterval = 0
        
        for card in cardViewDict.keys {
            if !game.currentCardsInGame.contains(card) {
                positionCardsAnimationDelay = freeFloatAnimationDuration
                animateRemoval(of: card)
                if let index = cardViewDict.index(forKey: card) {
                    cardViewDict.remove(at: index)
                }
            }
        }
    }
    
    private func animateRemoval(of card: Card){
        let cardView = findCardView(for: card)
        
        let pushBehavior = UIPushBehavior(items: [cardView], mode: .instantaneous)
        pushBehavior.magnitude = 1.0
        pushBehavior.angle = (CGFloat.pi * 2) * CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        cardView.layer.zPosition += 100
        animator.addBehavior(pushBehavior)
        
        timer = Timer.scheduledTimer(withTimeInterval: freeFloatAnimationDuration, repeats: false) { timer in
            pushBehavior.removeItem(cardView)
            pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: self.sendToDiscardPileAnimationDuration,
                delay: 0.0,
                options: [],
                animations: {
                    cardView.frame.size = self.deckConstants.discardPileRect.size
                    cardView.frame.origin = self.deckConstants.discardPileRect.origin
            }, completion: { finished in
                if cardView.isFaceUp {
                    UIView.transition(
                        with: cardView,
                        duration: self.flippingAnimationDuration,
                        options: [.transitionFlipFromLeft],
                        animations: {
                            cardView.isFaceUp = false
                    }, completion: { [weak self] finished in
                        if let realSelf = self, self?.discardView == nil {
                            let newDiscardPile = CardView(frame: realSelf.deckConstants.discardPileRect)
                            realSelf.cardsView.addSubview(newDiscardPile)
                            realSelf.discardView = newDiscardPile
                        }
                        cardView.removeFromSuperview()
                    })
                }
            })
        }
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
        scoreLabel.text = "Score: \(game.score)"
        
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
