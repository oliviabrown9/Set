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
    private var timer: Timer?
    
    @IBOutlet private weak var cardsView: UIView!
    
    var cardConstants: CardSizeConstants {
        if cardsView.bounds.height > cardsView.bounds.width {
            return CardSizeConstants(forGameSize: CGSize(
                width: cardsView.bounds.width,
                height: cardsView.bounds.height * (1 - bottomToHeightRatio)
            ), cardCount: game.currentCardsInGame.count)
        } else {
            return CardSizeConstants(forGameSize: CGSize(
                width: cardsView.bounds.width * (1 - sideToHeightRatio),
                height: cardsView.bounds.height
            ), cardCount: game.currentCardsInGame.count)
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let selectedCardView = sender.view else {
                return
            }
            var card: Card?
            for (key, value) in cardViewDict {
                if value == selectedCardView {
                    card = key
                    break
                }
            }
            if let foundCard = card {
                game.selectCard(card: foundCard)
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
        for card in cardViewDict.keys {
            animateRemoval(of: card)
        }
        cardViewDict.removeAll()
        updateViewFromModel()
    }
    
    private func dealThreeCards() {
        game.addThreeCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        
        createDeckView()
        addDiscardView()
        
        updateCardsOnScreen()
        animateCardViews()
    }
    
    private func updateCardsOnScreen() {
        for card in cardViewDict.keys {
            let currentCardView = findCardView(for: card)
            addOutline(to: currentCardView, withCard: card)
            if !game.currentCardsInGame.contains(card) {
                animateRemoval(of: card)
                if let index = cardViewDict.index(forKey: card) {
                    cardViewDict.remove(at: index)
                }
            }
        }
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
    
    // MARK: Animation functions
    private func animateCardViews() {
        var cardCount = 0
        
        for (index, card) in game.currentCardsInGame.enumerated() {
            let cardView = findCardView(for: card)
            if cardView.frame.origin == deckView?.frame.origin {
                cardCount += 1
            }
            let animationDelay = TimeInterval(cardCount) / 2
            placeView(forCard: card,
                      atRow: index / cardConstants.columnCount,
                      inColumn: index % cardConstants.columnCount,
                      withDelay: animationDelay)
        }
    }
    
    lazy var dynamicAnimator = UIDynamicAnimator(referenceView: cardsView)
    
    private func animateRemoval(of card: Card){
        let cardView = findCardView(for: card)
        
        let pushBehavior = UIPushBehavior(items: [cardView], mode: .instantaneous)
        pushBehavior.magnitude = 1.0
        pushBehavior.angle = (CGFloat.pi * 2) * CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        cardView.layer.zPosition += 100
        dynamicAnimator.addBehavior(pushBehavior)
        
        timer = Timer.scheduledTimer(withTimeInterval: matchDuration, repeats: false) { timer in
            pushBehavior.removeItem(cardView)
            pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: self.discardDuration,
                delay: 0.0,
                options: [],
                animations: {
                    cardView.frame.size = self.discardRect.size
                    cardView.frame.origin = self.discardRect.origin
            }, completion: { finished in
                if cardView.isFaceUp {
                    UIView.transition(
                        with: cardView,
                        duration: self.flipDuration,
                        options: [.transitionFlipFromLeft],
                        animations: {
                            cardView.isFaceUp = false
                    }, completion: { [weak self] finished in
                        if self?.discardView == nil {
                            let newDiscardPile = CardView(frame: self!.discardRect)
                            self?.cardsView.addSubview(newDiscardPile)
                            self?.discardView = newDiscardPile
                        }
                        cardView.removeFromSuperview()
                    })
                }
            })
        }
    }
    
    private func placeView(forCard card: Card, atRow row: Int, inColumn column: Int, withDelay delay: TimeInterval = 0.0) {
        let cardView = findCardView(for: card)
        var xOrigin = cardsView.bounds.origin.x + CGFloat(column) * cardConstants.cardWidth + (2 * CGFloat(column) + 1) * cardConstants.horizontalCardSeperation
        let yOrigin = cardsView.bounds.origin.y + CGFloat(row) * cardConstants.cardHeight + (2 * CGFloat(row) + 1) * cardConstants.verticalCardSeperation
        let cardSize = CGSize(width: cardConstants.cardWidth, height: cardConstants.cardHeight)
        
        if cardsView.bounds.height < cardsView.bounds.width {
            xOrigin += cardsView.bounds.width * sideToHeightRatio
        }
        
        func animateFromDeck() {
            UIViewPropertyAnimator.runningPropertyAnimator (
                withDuration: drawingCardDuration,
                delay: delay,
                options: [],
                animations: {
                    cardView.transform = CGAffineTransform.identity
                    if cardView.frame.width > cardView.frame.height {
                        cardView.transform = cardView.transform.rotated(by: CGFloat.pi / 2)
                    }
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
            }, completion: { finished in
                flipCardViewUp()
            })
        }
        
        func flipCardViewUp() {
            if !cardView.isFaceUp {
                UIView.transition(
                    with: cardView,
                    duration: self.flipDuration,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        cardView.isFaceUp = true
                })
            }
        }
        
        cardView.alpha = 1
        
        if cardView.frame.origin == deckView?.frame.origin {
            animateFromDeck()
        }
        else if cardView.frame.origin != CGPoint(x: xOrigin, y: yOrigin) {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: drawingCardDuration,
                delay: 0,
                options: [],
                animations: {
                    cardView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
                    cardView.frame.size = cardSize
            })
        }
        cardsView.addSubview(cardView)
    }
    
    // MARK: Handling views functions
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
            deckView = CardView(frame: deckRect)
            cardsView.addSubview(deckView!)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDeckTap))
            deckView!.addGestureRecognizer(tap)
        }
    }
    
    private func addDiscardView() {
        if let currentDiscardView = discardView {
            currentDiscardView.removeFromSuperview()
            discardView = CardView(frame: discardRect)
            cardsView.addSubview(discardView!)
        }
    }
    
    // MARK: Sizing functions and variables
    
    // Handles card area for orientation of device
    private func getCardArea() -> CGRect {
        if cardsView.bounds.height > cardsView.bounds.width {
            return CGRect(
                x: cardsView.bounds.origin.x,
                y: cardsView.bounds.origin.y + cardsView.bounds.height * (1 - bottomToHeightRatio),
                width: cardsView.bounds.width,
                height: cardsView.bounds.height * bottomToHeightRatio)
        }
        else {
            return CGRect(
                x: cardsView.bounds.origin.x,
                y: cardsView.bounds.origin.y,
                width: cardsView.bounds.width * sideToHeightRatio,
                height: cardsView.bounds.height)
        }
    }
    
    lazy private var cardArea = getCardArea()
    
    private var deckSize: CGSize {
        return CGSize(width: cardArea.width * deckWidthRatio,
                      height: cardArea.height * deckHeightRatio)
    }
    
    private var deckRect: CGRect {
        return CGRect(origin: CGPoint(x: cardArea.origin.x + cardArea.width * deckBorderRatio,
                                      y: cardArea.origin.y + cardArea.height * deckBorderRatio),
                      size: deckSize)
    }
    
    private var discardRect: CGRect {
        let origin: CGPoint = cardArea.height < cardArea.width
            ? CGPoint(x: cardArea.origin.x + cardArea.width - deckSize.width,
                      y: deckRect.minY)
            : CGPoint(x: deckRect.minX,
                      y: cardArea.origin.y + cardArea.height - deckSize.height * (1 + deckBorderRatio))
        return CGRect(origin: origin, size: deckSize)
    }
    
    // Constants
    private let cardAspectRatio: CGFloat = 5/8
    private let bottomToHeightRatio: CGFloat = 0.2
    private let sideToHeightRatio: CGFloat = 0.15
    private let drawingCardDuration: TimeInterval = 0.3
    private let flipDuration: TimeInterval = 1/2
    private let matchDuration: TimeInterval = 1/2
    private let discardDuration: TimeInterval = 1/20
    lazy private var deckWidthRatio: CGFloat = cardArea.height < cardArea.width ? 0.3 : 0.9
    lazy private var deckHeightRatio: CGFloat = cardArea.height < cardArea.width ? 0.9 : 0.3
    let deckBorderRatio: CGFloat = 0.025
    
}
