//
//  BlockView.swift
//  Breakout
//
//  Created by student on 05/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class SliderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blueColor()
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
