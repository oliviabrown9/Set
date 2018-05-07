////
////  CardsView.swift
////  Set
////
////  Created by Olivia Brown on 5/4/18.
////  Copyright © 2018 Olivia Brown. All rights reserved.
////
//
//import UIKit
//
//class CardsView: UIView {
//
//    private let cardAspectRatio: CGFloat = 5/8
//    private let cardGapRatio: CGFloat = 0.02
//    var cardViewsOnScreen = [CardView]() {
//        didSet {
//            oldValue.filter { !cardViewsOnScreen.contains($0) }
//            .forEach { triggerRemoveCardAnimation(onView: $0) }
//            setNeedsLayout()
//        }
//    }
//
//    var testFrame = CGRect()
//
//    private var horizontalPadding: CGFloat {
//        return 50 / CGFloat(cardViewsOnScreen.count)
//    }
//    private var verticalPadding: CGFloat {
//        return 20 / CGFloat(cardViewsOnScreen.count)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        var cardGrid = Grid(layout: .aspectRatio(cardAspectRatio), frame: bounds)
////        cardGrid.cellCount = cardViewsOnScreen.count
////
////        for cellIndex in 0..<cardGrid.cellCount {
////            if let cell = cardGrid[cellIndex] {
////                let cardView = cardViewsOnScreen[cellIndex]
////
////                if !subviews.contains(cardView) {
////                    addSubview(cardView)
////                    cardView.frame.origin = testFrame.origin
////                }
////                if cardView.frame.origin == testFrame.origin {
////                    UIViewPropertyAnimator.runningPropertyAnimator(
////                        withDuration: 0.8,
////                        delay: 1.5,
////                        options: [.curveEaseInOut],
////                        animations: {
////                            cardView.frame = cell
////                    }, completion: { finished in
////                        UIView.transition(
////                            with: cardView,
////                            duration: 0.5,
////                            options: [.transitionFlipFromLeft],
////                            animations: {
////                                cardView.isFaceUp = true
////                        })
////                    })
////                }
////            }
//        }
//    }
////
////    private func addGapBetweenCards(_ view: UIView, _ frame: CGRect) {
////        let gap = frame.width * cardGapRatio
////        let insetFrame = frame.insetBy(dx: gap, dy: gap)
////        view.frame.size = CGSize.init(width: insetFrame.width, height: insetFrame.height)
////        view.frame.origin = insetFrame.origin
////        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
////    }
//
//    private func triggerRemoveCardAnimation(onView view: UIView) {
//        UIView.transition(
//            with: view,
//            duration: 0.4,
//            options: [.curveEaseInOut],
//            animations: { view.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) },
//            completion: { finished in
//                UIView.transition(
//                    with: view,
//                    duration: 0.6,
//                    options: [.allowAnimatedContent],
//                    animations: {
//                        view.alpha = 0
//                        view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
//                },
//                    completion: {finished in view.removeFromSuperview()}
//                )
//        }
//        )
//    }
////}
