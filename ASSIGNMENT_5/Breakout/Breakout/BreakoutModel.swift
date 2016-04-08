//
//  BreakoutModel.swift
//  Breakout
//
//  Created by student on 08/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class BreakoutModel: NSObject {
    static func getClosestBall(atPoint point: CGPoint, forBalls balls: [BallView]) -> BallView {
        var currentMinDist = max((balls[0].superview?.bounds.width)!, (balls[0].superview?.bounds.height)!)
        var currentMinBall = balls[0]
        for ball in balls {
            let distance = sqrt(pow(ball.center.x - point.x, 2) + pow(ball.center.y - point.y, 2))
            if distance < currentMinDist {
                currentMinDist = distance
                currentMinBall = ball
            }
        }
        return currentMinBall
    }
    
    static func calculateScore(startTime: NSDate, blocksLeft: Int) -> Int {
        let timeInterval = NSDate().timeIntervalSinceDate(startTime)
        let numBlocks = (NSUserDefaults.standardUserDefaults().objectForKey(SettingsKeys.blocks) ?? 25) as? Int
        let brokenBlocks = Float(numBlocks! - blocksLeft)
        return Int((pow(brokenBlocks, 2) / Float(timeInterval)) * 1000)
    }
}