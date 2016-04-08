//
//  BlockView.swift
//  Breakout
//
//  Created by student on 05/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class BlockView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hue: CGFloat(rand()) / CGFloat(RAND_MAX), saturation: 1.0, brightness: 1.0, alpha: 0.5)
        layer.cornerRadius = min(frame.size.width, frame.size.height) / 5
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .Path
    }
    
    override var collisionBoundingPath: UIBezierPath {
        return UIBezierPath(rect: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
