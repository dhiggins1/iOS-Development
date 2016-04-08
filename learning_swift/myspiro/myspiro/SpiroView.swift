//
//  SpiroView.swift
//  myspiro
//
//  Created by student on 27/02/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

protocol SpiroDataSource: class {
    var circleRadius: CGFloat { get }
}

@IBDesignable
class SpiroView: UIView {
    
    var dataSource: SpiroDataSource?
    
    var circleScale:CGFloat = 0.85 { didSet { setNeedsDisplay() }}
    
    @IBInspectable
    var circleColour:UIColor = UIColor.blackColor()
    
    override func drawRect(rect: CGRect) {
        let drawCircle = UIBezierPath(arcCenter: center, radius: dataSource!.circleRadius * circleScale, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)
        circleColour.setStroke()
        drawCircle.lineWidth = 5
        drawCircle.stroke()
    }
    
    func calculateZoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            circleScale *= gesture.scale
            gesture.scale = 1.0
        }
    }
}