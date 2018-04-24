//
//  CardView.swift
//  Set
//
//  Created by Olivia Brown on 4/22/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var game: SetGame?
    
    let gapHeight: CGFloat = 0.11
    let cornerRadiusToBoundsHeight: CGFloat = 0.06
    let symbolCornerRadiusToBoundsHeight: CGFloat = 0.4
    let cardFrameInsetToBound: CGFloat = 0.07
    let controlPoint2_xToFrameWidth: CGFloat = 0.25
    let controlPoint2HeightToSymbolFrameHeight: CGFloat = 1.11
    let symbolGapHeightToSymbolFrameHeight: CGFloat = 0.11
    let twoSymbolOffsetToSymbolFrameHeight: CGFloat = 0.56
    let strokeWidthToSymbolFrameHeight: CGFloat = 0.12
    let stripeGapToSymbolFrameWidth: CGFloat = 0.17
    
    private var cornerRadius: CGFloat  {
        return bounds.size.height * cornerRadiusToBoundsHeight
    }
    private var symbolGapToCardEdge: CGFloat {
        return bounds.size.width * cardFrameInsetToBound
    }
    
    var associatedCard: Card? {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tap)
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let cardView = sender.view as? CardView else {
                return
            }
            if let selectedCard = cardView.associatedCard {
                game?.selectCard(card: selectedCard)
                
                for eachCard in (superview?.subviews)! {
                    if let eachCardView = eachCard as? CardView {
                        eachCardView.setNeedsLayout()
                        eachCardView.setNeedsDisplay()
                        superview?.setNeedsLayout()
                        superview?.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.white.setFill()
        cardBackground.fill()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setStroke()
        roundedRect.fill()
        
        let insetFrame = bounds.insetBy(dx: symbolGapToCardEdge, dy: symbolGapToCardEdge)
        let singleSymbolFrame = insetFrame.insetBy(dx: 0, dy: insetFrame.height/2.9)
        
        if let card = associatedCard {
            drawCardContent(forAssociatedCard: card, inRect: singleSymbolFrame)
            
            // Outlines the selected cards and changes color if a set is correct/incorrect
            if game!.selectedCards.contains(card) {
                if game!.setFound(withCards: game!.selectedCards) {
                    self.layer.borderColor = UIColor.green.cgColor
                    self.layer.borderWidth = 5.0
                }
                else if game!.selectedCards.count == 3 {
                    self.layer.borderColor = UIColor.red.cgColor
                    self.layer.borderWidth = 5.0
                }
                else {
                    self.layer.borderColor = UIColor.black.cgColor
                    self.layer.borderWidth = 5.0
                }
            }
            else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0.0
            }
        }
        
        
    }
    
    func drawCardContent(forAssociatedCard card: Card, inRect rect: CGRect) {
        var symbolFrame = rect
        let symbolGap = symbolFrame.height * symbolGapHeightToSymbolFrameHeight
        
        switch card.number {
        case .A:
            break
        case .B:
            symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height * twoSymbolOffsetToSymbolFrameHeight)
        case .C:
            symbolFrame = symbolFrame.offsetBy(dx: 0, dy: -symbolFrame.height-symbolGap)
        }
        
        var color: UIColor
        switch card.color {
        case .A:
            color = UIColor.blue
        case .B:
            color = UIColor.purple
        case .C:
            color = UIColor.green
        }
        
        for _ in 0...card.number.rawValue {
            var symbolPath: UIBezierPath
            switch card.symbol {
            case .A:
                symbolPath = makeDiamondPath(inFrame: symbolFrame)
            case .B:
                symbolPath = makeSquigglePath(inFrame: symbolFrame)
            case .C:
                symbolPath = makeTrianglePath(inFrame: symbolFrame)
            }

            switch card.shading {
            case .A:
                color.setFill()
                symbolPath.fill()
            case .B:
                symbolPath.lineWidth = frame.width * 0.05
                color.setStroke()
                symbolPath.stroke()
            case .C:
                symbolPath.lineWidth = frame.width * 0.05
                color.setStroke()
                symbolPath.stroke()
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                symbolPath.addClip()
                symbolPath.lineWidth = frame.width * 0.02
                for i in stride(from: 0, to: bounds.maxY, by: 5) {
                    symbolPath.move(to: CGPoint(x: 0, y: i))
                    symbolPath.addLine(to: CGPoint(x: bounds.maxX, y: i))
                }
                symbolPath.stroke()
                context?.restoreGState()
            }
            symbolFrame = symbolFrame.offsetBy(dx: 0, dy: symbolGap + symbolFrame.height)
        }
    }
        
    private func makeDiamondPath(inFrame frame: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: frame, cornerRadius: frame.height * symbolCornerRadiusToBoundsHeight)
    }
    
    private func makeSquigglePath(inFrame frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX, y: frame.maxY))
        path.addCurve(to: CGPoint(x: frame.maxX, y: frame.minY),
                      controlPoint1: CGPoint(x: frame.minX , y: frame.minY - frame.height * controlPoint2HeightToSymbolFrameHeight),
                      controlPoint2: CGPoint(x: frame.maxX - controlPoint2_xToFrameWidth * frame.width, y: frame.maxY))
        path.addCurve(to: CGPoint(x: frame.minX, y: frame.maxY),
                      controlPoint1: CGPoint(x: frame.maxX , y: frame.maxY + frame.height * controlPoint2HeightToSymbolFrameHeight),
                      controlPoint2: CGPoint(x: frame.minX + controlPoint2_xToFrameWidth*frame.width, y: frame.minY))
        return path
    }
    
    private func makeTrianglePath(inFrame frame: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.minX, y: frame.maxY - frame.height/2))
        path.addLine(to: CGPoint(x: frame.maxX - frame.width/2, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY + frame.height/2))
        path.addLine(to: CGPoint(x: frame.minX + frame.width/2, y: frame.maxY))
        path.close()
        
        return path
    }
}
