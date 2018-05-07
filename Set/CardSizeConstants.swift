//
//  DeckConstants.swift
//  Set
//
//  Created by Olivia Brown on 5/6/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import Foundation
import UIKit

struct CardSizeConstants {
    private let cardSeperationToCardHeight: CGFloat = 0.025
    private let cardSeperationToCardWidth: CGFloat = 0.05
    
    let cardHeight: CGFloat
    let cardWidth: CGFloat
    let verticalCardSeperation: CGFloat
    let horizontalCardSeperation: CGFloat
    let columnCount: Int
    let rowCount: Int
    
    init(forGameSize size: CGSize, cardCount: Int) {
        columnCount = size.height > size.width ? 4 : 6
        rowCount = Int(ceil(Double(cardCount) / Double(columnCount)))
        
        let baseWidth = size.width / CGFloat(columnCount)
        let baseHeight = size.height / CGFloat(rowCount)
        
        horizontalCardSeperation = baseWidth * cardSeperationToCardWidth
        verticalCardSeperation = baseHeight * cardSeperationToCardHeight
        
        cardWidth = baseWidth - 2 * horizontalCardSeperation
        cardHeight = baseHeight - 2 * verticalCardSeperation
    }
}

struct DeckSizeConstants {
    private let deckHorizontalBorderToSizeRatio: CGFloat = 0.025
    private let deckVerticalBorderToSizeRatio: CGFloat = 0.025
    
    private var deckSize: CGSize
    var deckRect: CGRect
    var discardPileRect: CGRect
    
    init(forViewBounds bounds: CGRect) {
        let deckWidthToBoundsWidth: CGFloat = bounds.height < bounds.width ? 0.475 : 0.9
        let deckHeightToBoundsHeight: CGFloat = bounds.height < bounds.width ? 0.9 : 0.475
        
        deckSize = CGSize(width: bounds.width * deckWidthToBoundsWidth, height: bounds.height * deckHeightToBoundsHeight)
        
        deckRect = CGRect(origin: CGPoint(x: bounds.origin.x + deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio), size: deckSize)
        
        let discardPileOrigin: CGPoint = bounds.height < bounds.width
            ? CGPoint(x: bounds.origin.x + deckSize.width + 2 * deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height * deckVerticalBorderToSizeRatio)
            : CGPoint(x: bounds.origin.x + deckSize.width * deckHorizontalBorderToSizeRatio, y: bounds.origin.y + deckSize.height + 2 * deckSize.height * deckVerticalBorderToSizeRatio)
        discardPileRect = CGRect(origin: discardPileOrigin, size: deckSize)
    }
}

