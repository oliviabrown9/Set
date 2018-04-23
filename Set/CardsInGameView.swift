//
//  CardsView.swift
//  Set
//
//  Created by Olivia Brown on 4/22/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class CardsInGameView: UIView {
    
    let cardAspectRatio: CGFloat = 5/8
    
    lazy private var cardGrid = Grid(layout: Grid.Layout.aspectRatio(cardAspectRatio))
    var cardsInGameViews = [CardView]() {
        didSet {
            layoutSubviews()
        }
    }

    override func layoutSubviews() {
        cardGrid.cellCount = cardsInGameViews.count
        cardGrid.frame = bounds
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for index in cardsInGameViews.indices {
            let cardView = cardsInGameViews[index]
            if let cardRect = cardGrid[index] {
                cardView.frame = cardRect
                addSubview(cardsInGameViews[index])
            }
        }
    }
}
