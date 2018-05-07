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
    private let deckSubviewIndex = 1
    
    @IBOutlet private weak var cardsView: UIView!
    
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
    
    var cardConstants: CardSizeConstants {
        if cardsView.bounds.height > cardsView.bounds.width {
            return CardSizeConstants(forGameSize: CGSize(
                width: cardsView.bounds.width,
                height: cardsView.bounds.height * (1 - bottomViewToBoundsHeightRatio)
            ), cardCount: game.currentCardsInGame.count)
        } else {
            return CardSizeConstants(forGameSize: CGSize(
                width: cardsView.bounds.width * (1 - sideViewToBoundsWidthRatio),
                height: cardsView.bounds.height
            ), cardCount: game.currentCardsInGame.count)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDeckTap))
            deckView!.addGestureRecognizer(tap)
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
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let selectedCardView = sender.view else {
                return
            }
            if let cardIndex = cardsView.subviews.index(of: selectedCardView) {
                game.selectCard(card: game.currentCardsInGame[cardIndex - 1])
            }
            updateViewFromModel()
        }
    }
    
    @objc private func handleDeckTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if !game.deck.cards.isEmpty {
                dealThreeCards()
            }
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBAction private func newGame(_ sender: UIButton) {
        game.newGame()
        updateViewFromModel()
    }
    
    private func dealThreeCards() {
        game.addThreeCards()
        updateViewFromModel()
    }
    
    private let cardAspectRatio: CGFloat = 5/8
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        
        createDeckView()
        createDiscardView()
        
        var positionCardsAnimationDelay: TimeInterval = 0
        
        for card in cardViewDict.keys {
            let currentCardView = findCardView(for: card)
            addOutline(to: currentCardView, withCard: card)
            if !game.currentCardsInGame.contains(card) {
                positionCardsAnimationDelay = freeFloatAnimationDuration
                animateRemoval(of: card)
                if let index = cardViewDict.index(forKey: card) {
                    cardViewDict.remove(at: index)
                }
            }
        }
        
        var newCardCount = -1
        
        for (index,card) in game.currentCardsInGame.enumerated() {
            
            let cardView = findCardView(for: card)
            if cardView.frame.origin == deckView?.frame.origin { newCardCount += 1 }
            let animationDelay = positionCardsAnimationDelay + TimeInterval(newCardCount) * drawingAnimationDuration
            positionCard(card, rowIndex: index / cardConstants.columnCount, columnIndex: index % cardConstants.columnCount, animationDelay: animationDelay)
        }
    }
    
    private func positionCard(_ card: Card, rowIndex row: Int, columnIndex column: Int, animationDelay: TimeInterval = 0.0) {
        let cardView = findCardView(for: card)
        
        var xOrigin = cardsView.bounds.origin.x + CGFloat(column) * cardConstants.cardWidth + (2 * CGFloat(column) + 1) * cardConstants.horizontalCardSeperation
        let yOrigin = cardsView.bounds.origin.y + CGFloat(row) * cardConstants.cardHeight + (2 * CGFloat(row) + 1) * cardConstants.verticalCardSeperation
        let cardSize = CGSize(width: cardConstants.cardWidth, height: cardConstants.cardHeight)
        
        if cardsView.bounds.height < cardsView.bounds.width {
            xOrigin += cardsView.bounds.width * sideViewToBoundsWidthRatio
        }
        
        cardView.alpha = 1
        
        if cardView.frame.origin == deckView?.frame.origin {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: drawingAnimationDuration,
                delay: animationDelay,
                options: [],
                animations: {
                    cardView.transform = CGAffineTransform.identity
                    if cardView.frame.width > cardView.frame.height {
                        cardView.transform = cardView.transform.rotated(by: CGFloat.pi / 2)
                    }
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
            }, completion: { finished in
                if !cardView.isFaceUp {
                    UIView.transition(
                        with: cardView,
                        duration: self.flippingAnimationDuration,
                        options: [.transitionFlipFromLeft],
                        animations: {
                            cardView.isFaceUp = true
                    })
                }
            })
        } else if cardView.frame.origin != CGPoint(x: xOrigin, y: yOrigin) {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: drawingAnimationDuration,
                delay: 0,
                options: [],
                animations: {
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
            })
        }
        
        cardsView.addSubview(cardView)
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
