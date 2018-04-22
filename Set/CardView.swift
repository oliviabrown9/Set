//
//  CardView.swift
//  Set
//
//  Created by Olivia Brown on 4/22/18.
//  Copyright © 2018 Olivia Brown. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 15.0)
        roundedRect.addClip()
        UIColor.white.setFill()
    }

}
