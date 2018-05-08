//
//  ViewController.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private(set) var game = SetGame()
    
    private var deckView: SetCardView?
    private var discardView: SetCardView?
    private var cardViewDict = [SetCard: SetCardView]()
    private var timer: Timer?
    
    @IBOutlet private weak var cardsView: UIView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @objc private func handleCardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let selectedCardView = sender.view else {
                return
            }
            var card: SetCard?
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
    
    private func addOutline(to cardView: SetCardView, withCard card: SetCard) {
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
    
    private func setCardViewAttributes(fromCard card: SetCard, forView view: SetCardView) {
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
            let column = index % numColumns
            let row = index / numColumns
            var xOrigin = cardsView.bounds.origin.x + CGFloat(column) * cardSize.width + (2 * CGFloat(column) + 1) * cardWidthGap
            let yOrigin = cardsView.bounds.origin.y + CGFloat(row) * cardSize.height + (2 * CGFloat(row) + 1) * cardHeightGap
            if cardsView.bounds.height < cardsView.bounds.width {
                xOrigin += cardsView.bounds.width * sideToHeightRatio
            }
            placeView(cardView, withDelay: animationDelay, atLocation: (xOrigin, yOrigin))
        }
    }
    
    private lazy var dynamicAnimator = UIDynamicAnimator(referenceView: cardsView)
    
    private func animateRemoval(of card: SetCard) {
        let cardView = findCardView(for: card)
        
        let pushBehavior = UIPushBehavior(items: [cardView], mode: .instantaneous)
        pushBehavior.magnitude = 1.0
        pushBehavior.angle = (CGFloat.pi * 2) * CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        dynamicAnimator.addBehavior(pushBehavior)
        
        timer = Timer.scheduledTimer(withTimeInterval: matchDuration, repeats: false) { timer in
            pushBehavior.removeItem(cardView)
            pushBehavior.dynamicAnimator?.removeBehavior(pushBehavior)
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: self.discardDuration, delay: 0.0, options: [], animations: {
                    cardView.frame.size = self.discardRect.size
                    cardView.frame.origin = self.discardRect.origin
            }, completion: { finished in
                self.discard(cardView)
            })
        }
    }
    
    private func discard(_ cardView: SetCardView) {
        if cardView.isFaceUp {
            UIView.transition(
                with: cardView,
                duration: self.flipDuration,
                options: [.transitionFlipFromLeft],
                animations: {
                    cardView.isFaceUp = false
            }, completion: { [weak self] finished in
                if self?.discardView == nil {
                    let newDiscardPile = SetCardView(frame: self!.discardRect)
                    self?.cardsView.addSubview(newDiscardPile)
                    self?.discardView = newDiscardPile
                }
                cardView.removeFromSuperview()
            })
        }
    }
    
    private func placeView(_ cardView: SetCardView, withDelay delay: TimeInterval, atLocation location: (CGFloat, CGFloat)) {
        if cardView.frame.origin == deckView?.frame.origin {
            UIViewPropertyAnimator.runningPropertyAnimator (
                withDuration: drawingCardDuration, delay: delay, options: [],
                animations: {
                    cardView.frame.origin = CGPoint(x: location.0, y: location.1)
                    cardView.frame.size = self.cardSize
            }, completion: { finished in
                self.flipUp(cardView)
            })
        }
        else if cardView.frame.origin != CGPoint(x: location.0, y: location.1) {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: drawingCardDuration, delay: 0, options: [],
                animations: {
                    cardView.frame.origin = CGPoint(x: location.0, y: location.1)
                    cardView.frame.size = self.cardSize
            })
        }
        cardsView.addSubview(cardView)
    }
    
    private func flipUp(_ cardView: SetCardView) {
        if !cardView.isFaceUp {
            UIView.transition(
                with: cardView, duration: self.flipDuration, options: [.transitionFlipFromLeft],
                animations: {
                    cardView.isFaceUp = true
            })
        }
    }
    
    // MARK: Handling views functions
    private func findCardView(for card: SetCard) -> SetCardView {
        if cardViewDict[card] == nil {
            cardViewDict[card] = createCardView(for: card)
        }
        return cardViewDict[card]!
    }
    
    private func createCardView(for card: SetCard) -> SetCardView {
        let cardView = SetCardView()
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
            deckView = SetCardView(frame: deckRect)
            cardsView.addSubview(deckView!)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleDeckTap))
            deckView!.addGestureRecognizer(tap)
        }
    }
    
    private func addDiscardView() {
        if let currentDiscardView = discardView {
            currentDiscardView.removeFromSuperview()
            discardView = SetCardView(frame: discardRect)
            cardsView.addSubview(discardView!)
        }
    }
    
    // MARK: Sizing functions and variables
    
    private var cardSize: CGSize {
        return getCardSize(for: cardsViewWithBoundsSize, withNumCards: game.currentCardsInGame.count)
    }
    private var numColumns: Int {
        return cardsViewWithBoundsSize.height > cardsViewWithBoundsSize.width ? 4 : 6
    }
    private var columnWidth: CGFloat {
        return cardsViewWithBoundsSize.width / CGFloat(numColumns)
    }
    private var cardWidthGap: CGFloat {
        return columnWidth * cardWidthGapRatio
    }
    private var numRows: Int {
        return Int(ceil(Double(game.currentCardsInGame.count) / Double(numColumns)))
    }
    private var rowHeight: CGFloat {
        return cardsViewWithBoundsSize.height / CGFloat(numRows)
    }
    private var cardHeightGap: CGFloat {
        return rowHeight * cardHeightGapRatio
    }
    private var deckWidthRatio: CGFloat {
        return cardArea.height < cardArea.width ? 0.3 : 0.9
    }
    private var deckHeightRatio: CGFloat {
        return cardArea.height < cardArea.width ? 0.9 : 0.3
    }
    
    private var cardsViewWithBoundsSize: CGSize {
        if cardsView.bounds.height > cardsView.bounds.width {
            return CGSize(width: cardsView.bounds.width, height: cardsView.bounds.height * (1 - bottomToHeightRatio))
        }
        else {
            return CGSize(width: cardsView.bounds.width * (1 - sideToHeightRatio), height: cardsView.bounds.height)
        }
    }
    
    private func getCardSize(for size: CGSize, withNumCards cardCount: Int) -> CGSize {
        let cardWidth = columnWidth - 2 * cardWidthGap
        let cardHeight = rowHeight - 2 * cardHeightGap
        
        return CGSize(width: cardWidth, height: cardHeight)
    }
    
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
    
    private var cardArea: CGRect {
        return getCardArea()
    }
    
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
    private let deckBorderRatio: CGFloat = 0.025
    private let cardHeightGapRatio: CGFloat = 0.025
    private let cardWidthGapRatio: CGFloat = 0.05
    
}
