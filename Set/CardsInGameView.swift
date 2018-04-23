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
    var game: SetGame?
    
    lazy private var cardGrid = Grid(layout: Grid.Layout.aspectRatio(cardAspectRatio))
    let cardEdgeWidthToCellFrameSize: CGFloat = 0.02
    
    override func layoutSubviews() {
        guard let setGame = game else {
            return
        }
        
        cardGrid.cellCount = setGame.currentCardsInGame.count
        cardGrid.frame = bounds
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for index in 0..<cardGrid.cellCount {
            let cardView = CardView()
            cardView.associatedCard = setGame.currentCardsInGame[index]
            addSubview(cardView)
            configureCardView(cardView, cardGrid[index]!)
            cardView.frame.origin = cardGrid[index]!.origin
        }
    }
    private func configureCardView(_ view: UIView, _ frame: CGRect) {
        let delta = frame.width * cardEdgeWidthToCellFrameSize
        let insetFrame = frame.insetBy(dx: delta, dy: delta)
        view.frame.size = CGSize.init(width: insetFrame.width, height: insetFrame.height)
        view.frame.origin = insetFrame.origin
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
}
