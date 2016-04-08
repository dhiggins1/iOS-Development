//
//  MyMapView.swift
//  transNav
//
//  Created by student on 29/02/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

protocol MapDataSource: class {
    func vertices (bounds: CGRect) -> [CGPoint]
    func drawIndices() -> [Int]
}

class MyMapView: UIView {
    var dataSource: MapDataSource?
    
    override func drawRect(rect: CGRect) {
        if let vertices = dataSource?.vertices(bounds) {
            var path = UIBezierPath()
            for vertex in vertices {
                print(vertex)
                path.appendPath(UIBezierPath(arcCenter: vertex, radius: 2.0, startAngle: 0.0, endAngle: CGFloat(2.0*M_PI), clockwise: true))
            }
            UIColor.lightGrayColor().colorWithAlphaComponent(0.5).setStroke()
            path.lineWidth = 5
            path.stroke()
            if let lineIndices = dataSource?.drawIndices() {
                path = UIBezierPath()
                path.moveToPoint(vertices[0])
                for index in lineIndices {
                    path.addLineToPoint(vertices[index])
                }
                path.lineWidth = 2
                path.stroke()
            }
        }
    }
}
