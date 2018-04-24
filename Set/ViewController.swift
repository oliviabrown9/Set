//
//  ViewController.swift
//  Set
//
//  Created by Olivia Brown on 4/15/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cardAspectRatio: CGFloat = 5/8
    
    private(set) var game = SetGame()
    @IBOutlet weak var cardsView: UIView! {
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
    
    @objc func handleRotate(sender: UIRotationGestureRecognizer) {
        print("rotate")
        if sender.state == .ended {
            game.shuffleCardsInGame()
            updateViewFromModel()
        }
    }
    
    @objc func handleSwipeDown(sender: UISwipeGestureRecognizer) {
        print("swipe down")
        if sender.state == .ended {
            game.addThreeCards()
            updateViewFromModel()
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
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
    
    let cardEdgeWidthToCellFrameSize: CGFloat = 0.02
    
    private func addGapBetweenCards(_ view: UIView, _ frame: CGRect) {
        let delta = frame.width * cardEdgeWidthToCellFrameSize
        let insetFrame = frame.insetBy(dx: delta, dy: delta)
        view.frame.size = CGSize.init(width: insetFrame.width, height: insetFrame.height)
        view.frame.origin = insetFrame.origin
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    private func updateViewFromModel() {
        for view in cardsView.subviews {
            view.removeFromSuperview()
        }
        
        var cardGrid = Grid(layout: .aspectRatio(cardAspectRatio), frame: cardsView.bounds)
        cardGrid.cellCount = game.currentCardsInGame.count
        
        for cellIndex in 0..<cardGrid.cellCount {
            if let cell = cardGrid[cellIndex] {
                let cardView = CardView()
                cardView.frame = cell
                cardView.isOpaque = false
                
                if let card = game.currentCardsInGame.indices.contains(cellIndex) ? game.currentCardsInGame[cellIndex] : nil {
                    switch card.color {
                    case .A : cardView.color = .A
                    case .B : cardView.color = .B
                    case .C : cardView.color = .C
                    }
                    switch card.number {
                    case .A : cardView.number = .A
                    case .B : cardView.number = .B
                    case .C : cardView.number = .C
                    }
                    switch card.shading {
                    case .A : cardView.shading = .A
                    case .B : cardView.shading = .B
                    case .C : cardView.shading = .C
                    }
                    switch card.symbol {
                    case .A : cardView.symbol = .A
                    case .B : cardView.symbol = .B
                    case .C : cardView.symbol = .C
                    }
                    
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
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                    cardView.addGestureRecognizer(tap)
                    addGapBetweenCards(cardView, cardGrid[cellIndex]!)
                    cardsView.addSubview(cardView)
                }
            }
        }
    
        // Update the ability to deal three more cards & update score label
        if game.deck.cards.isEmpty {
            dealThreeCardsButton.isEnabled = false
        }
        scoreLabel.text = "Score: \(game.score)"
    }
}

