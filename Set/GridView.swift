//
//  GridView.swift
//  Set
//
//  Created by Olivia Brown on 5/4/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    private let cardAspectRatio: CGFloat = 5/8
    private let cardGapRatio: CGFloat = 0.02
    var cardViewsOnScreen = [CardView]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        var cardGrid = Grid(layout: .aspectRatio(cardAspectRatio), frame: bounds)
        cardGrid.cellCount = cardViewsOnScreen.count
        
        for cellIndex in 0..<cardGrid.cellCount {
            if let cell = cardGrid[cellIndex] {
                let cardView = cardViewsOnScreen[cellIndex]
                if !subviews.contains(cardView) {
                    addSubview(cardView)
                }
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.8,
                    delay: 1.5,
                    options: [],
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
}
