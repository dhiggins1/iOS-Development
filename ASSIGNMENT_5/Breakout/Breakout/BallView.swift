//
//  BlockView.swift
//  Breakout
//
//  Created by student on 05/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class BallView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.redColor()
        layer.cornerRadius = frame.size.width / 2
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Ellipse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
