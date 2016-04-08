//
//  MapModel.swift
//  transNav
//
//  Created by student on 29/02/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class MapModel {
    
    var vertices = [CGPoint]()
    var indices = [Int]()
    
    func updateVertices(bounds: CGRect) -> [CGPoint] {
        vertices = [CGPoint]()
        for var i = 0; i < 5; i++ {
            vertices.append(CGPoint(
                x: CGFloat(arc4random_uniform(UInt32(min(bounds.size.height, bounds.size.width)))),
                y: CGFloat(arc4random_uniform(UInt32(min(bounds.size.height, bounds.size.width))))))
        }
        return vertices
    }
    
    func addVertex(point: CGPoint) {
        let index = vertices.endIndex
        vertices.append(point)
        indices.append(index)
    }
    
    func updateIndices() -> [Int] {
        indices = [Int(arc4random_uniform(UInt32(vertices.endIndex))), Int(arc4random_uniform(UInt32(vertices.endIndex)))]
        return indices
    }
}