//
//  CardView.swift
//  Set
//
//  Created by Olivia Brown on 4/22/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class CardView: UIView {

    // Constants
    let symbolGapRatio: CGFloat = 0.2
    let twoSymbolGapRatio: CGFloat = 0.6
    let strokeLineWidthRatio: CGFloat = 0.02
    let oneSymbolHeightRatio: CGFloat = 2.6
    let cornerRadiusRatio: CGFloat = 0.1
    let cardEdgeInset: CGFloat = 0.1
    let squiggleRatio: CGFloat = 0.3
    
    enum CardViewAttribute: Int {
        case A, B, C
    }
    
    var color: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var symbol: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var number: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var shading: CardViewAttribute = .A { didSet { setNeedsDisplay() }}
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height * cornerRadiusRatio)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        drawCardContent(inFrame: bounds.insetBy(dx: bounds.size.width * cardEdgeInset, dy: bounds.height/oneSymbolHeightRatio))
    }
    
    func drawCardContent(inFrame frameRect: CGRect) {
        var symbolBounds = frameRect
        
        switch number {
        case .A: break
        case .B: symbolBounds = symbolBounds.offsetBy(dx: 0, dy: -symbolBounds.height * twoSymbolGapRatio)
        case .C: symbolBounds = symbolBounds.offsetBy(dx: 0, dy: -symbolBounds.height - symbolBounds.height * symbolGapRatio)
        }
        
        var cardColor: UIColor
        switch color {
        case .A: cardColor = UIColor.magenta
        case .B: cardColor = UIColor.purple
        case .C: cardColor = UIColor.orange
        }
        
        for _ in 0...number.rawValue {
            var symbolPath: UIBezierPath
            switch symbol {
            case .A: symbolPath = makeOvalPath(inBounds: symbolBounds)
            case .B: symbolPath = makeSquigglePath(inBounds: symbolBounds)
            case .C: symbolPath = makeDiamondPath(inBounds: symbolBounds)
            }

            switch shading {
            case .A:
                cardColor.setFill()
                symbolPath.fill()
            case .B:
                symbolPath.lineWidth = frame.width * strokeLineWidthRatio
                cardColor.setStroke()
                symbolPath.stroke()
            case .C:
                addStripes(toPath: symbolPath, inColor: cardColor)
            }
            symbolBounds = symbolBounds.offsetBy(dx: 0, dy: symbolBounds.height * symbolGapRatio + symbolBounds.height)
        }
    }
    
    private func addStripes(toPath path: UIBezierPath, inColor cardColor: UIColor) {
        path.lineWidth = frame.width * strokeLineWidthRatio
        cardColor.setStroke()
        path.stroke()
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        path.lineWidth = frame.width * strokeLineWidthRatio
        for yValue in stride(from: 0, to: bounds.maxY, by: 8) {
            path.move(to: CGPoint(x: 0, y: yValue))
            path.addLine(to: CGPoint(x: bounds.maxX, y: yValue))
        }
        path.stroke()
        context?.restoreGState()
    }
        
    private func makeOvalPath(inBounds bounds: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: bounds)
    }
    
    private func makeSquigglePath(inBounds bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addCurve(to: CGPoint(x: bounds.maxX, y: bounds.minY),
                      controlPoint1: CGPoint(x: bounds.minX , y: bounds.minY - bounds.height),
                      controlPoint2: CGPoint(x: bounds.maxX - squiggleRatio * bounds.width, y: bounds.maxY))
        path.addCurve(to: CGPoint(x: bounds.minX, y: bounds.maxY),
                      controlPoint1: CGPoint(x: bounds.maxX , y: bounds.maxY + bounds.height),
                      controlPoint2: CGPoint(x: bounds.minX + squiggleRatio * bounds.width, y: bounds.minY))
        return path
    }
    
    private func makeDiamondPath(inBounds bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY - bounds.height/2))
        path.addLine(to: CGPoint(x: bounds.maxX - bounds.width/2, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY + bounds.height/2))
        path.addLine(to: CGPoint(x: bounds.minX + bounds.width/2, y: bounds.maxY))
        path.close()
        
        return path
    }
}
