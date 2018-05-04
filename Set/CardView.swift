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
    private let symbolGapRatio: CGFloat = 0.2
    private let twoSymbolGapRatio: CGFloat = 0.6
    private let strokeLineWidthRatio: CGFloat = 0.02
    private let oneSymbolHeightRatio: CGFloat = 2.6
    private let cornerRadiusRatio: CGFloat = 0.1
    private let cardEdgeInset: CGFloat = 0.1
    private let squiggleRatio: CGFloat = 0.3
    private let stripeStride: CGFloat = 8
    
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    enum CardViewAttribute: Int {
        case A, B, C
    }
    
    var color: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var symbol: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var number: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    var shading: CardViewAttribute = .A { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.size.height * cornerRadiusRatio)
        roundedRect.addClip()
        if isFaceUp {
            UIColor.white.setFill()
            roundedRect.fill()
            drawCardContent(inFrame: bounds.insetBy(dx: bounds.size.width * cardEdgeInset, dy: bounds.height/oneSymbolHeightRatio))
        }
        else {
            UIColor.purple.setFill()
            roundedRect.fill()
        }
        
    }
    
    private func drawCardContent(inFrame frameRect: CGRect) {
        var symbolBounds = getSymbolBounds(forFrame: frameRect)
        let cardColor = getCardColor()
        
        for _ in 0...number.rawValue {
            let symbolPath = getSymbolPath(inBounds: symbolBounds)
            addShading(toPath: symbolPath, withColor: cardColor)
            symbolBounds = symbolBounds.offsetBy(dx: 0, dy: symbolBounds.height * symbolGapRatio + symbolBounds.height)
        }
    }
    
    private func addShading(toPath symbolPath: UIBezierPath, withColor cardColor: UIColor) {
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
    }
    
    private func getSymbolPath(inBounds symbolBounds: CGRect) -> UIBezierPath {
        switch symbol {
        case .A: return makeOvalPath(inBounds: symbolBounds)
        case .B: return makeSquigglePath(inBounds: symbolBounds)
        case .C: return makeDiamondPath(inBounds: symbolBounds)
        }
    }
    
    private func getSymbolBounds(forFrame frameRect: CGRect) -> CGRect {
        var symbolBounds = frameRect
        
        switch number {
        case .A: break
        case .B: symbolBounds = symbolBounds.offsetBy(dx: 0, dy: -symbolBounds.height * twoSymbolGapRatio)
        case .C: symbolBounds = symbolBounds.offsetBy(dx: 0, dy: -symbolBounds.height - symbolBounds.height * symbolGapRatio)
        }
        
        return symbolBounds
    }
    
    private func getCardColor() -> UIColor {
        switch color {
        case .A: return UIColor.magenta
        case .B: return UIColor.purple
        case .C: return UIColor.orange
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
        for yValue in stride(from: 0, to: bounds.maxY, by: stripeStride) {
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
    
    func cardsMatchAnimation(completion: (() -> Swift.Void)? = nil)  {
        let matchCardAnimationDuration: TimeInterval = 0.6
        let matchCardAnimationScaleUp: CGFloat = 3.0
        let matchCardAnimationScaleDown: CGFloat = 0.1
        let animator = UIViewPropertyAnimator(
            duration: matchCardAnimationDuration,
            curve: .linear ,
            animations: {
                self.center = self.superview!.center
                self.transform = CGAffineTransform.identity.scaledBy(x: matchCardAnimationScaleUp,
                                                                     y: matchCardAnimationScaleUp)
        })
        animator.addCompletion({ position in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: matchCardAnimationDuration,
                delay: 0, options: [],
                animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: matchCardAnimationScaleDown,
                                                                         y: matchCardAnimationScaleDown)
                    self.alpha = 0
            },
                completion: { position in
                    self.isHidden = true
                    self.alpha = 1
                    self.transform = .identity
            }
            )
        })
        animator.addCompletion({ position in
            completion?()
        })
        animator.startAnimation()
    }
    
    func flipCard(completion: (() -> Swift.Void)? = nil)  {
                let flipCardAnimationDuration: TimeInterval = 0.6
        UIView.transition(
            with: self,
            duration: flipCardAnimationDuration,
            options: [.transitionFlipFromLeft],
            animations: { self.isFaceUp = !self.isFaceUp },
            completion: { position in
                completion?()
        }
        )
    }
}
