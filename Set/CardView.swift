//
//  CardView.swift
//  Set
//
//  Created by Olivia Brown on 4/22/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class CardView: UIView {
    
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
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.black.setFill()
        cardBackground.fill()
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setStroke()
        roundedRect.fill()
        
        let insetFrame = bounds.insetBy(dx: symbolGapToCardEdge, dy: symbolGapToCardEdge)
        let singleSymbolFrame = insetFrame.insetBy(dx: 0, dy: insetFrame.height/2.9)
        
        if let card = associatedCard {
            drawCardContent(forAssociatedCard: card, inRect: singleSymbolFrame)
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
                symbolPath.lineWidth = frame.height * strokeWidthToSymbolFrameHeight
                color.setStroke()
                symbolPath.stroke()
            case .C:
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                symbolPath.addClip()
                var xPoint = frame.minX + stripeGapToSymbolFrameWidth * frame.width
                while xPoint < frame.maxX {
                    let line = UIBezierPath()
                    line.move(to: CGPoint(x: xPoint, y: frame.minY))
                    line.addLine(to: CGPoint(x: xPoint, y: frame.maxY))
                    line.lineWidth = frame.height * strokeWidthToSymbolFrameHeight
                    color.setStroke()
                    line.stroke()
                    xPoint = xPoint + stripeGapToSymbolFrameWidth*frame.width
                }
                context?.restoreGState()
                color.setStroke()
                symbolPath.lineWidth = frame.height * strokeWidthToSymbolFrameHeight
                symbolPath.stroke()
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
