//
//  BreakoutBehaviour.swift
//  Breakout
//
//  Created by student on 04/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

protocol BreakoutCollisionDelegate {
    func ballCollidedWithBlock(blockId: NSCopying) -> Void
    func ballNotInView(ball: BallView) -> Void
}

struct Boundaries {
    static let left = "boundaryLeft"
    static let right = "boundaryRight"
    static let top = "boundaryTop"
    static let slider = "slider"
}

struct Constants {
    static let maxVelocity: CGFloat = 1000
}

class BreakoutBehaviour: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    var breakoutCollisionDelegate: BreakoutCollisionDelegate?
    
    private lazy var collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        collider.translatesReferenceBoundsIntoBoundary = false
        collider.collisionDelegate = self
        collider.action = { [unowned self] in
            for item in collider.items {
                if let ball = item as? BallView {
                    if !CGRectIntersectsRect((self.dynamicAnimator?.referenceView?.bounds)!, ball.frame) {
                        self.breakoutCollisionDelegate?.ballNotInView(ball)
                    }
                }
            }
        }
        return collider
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehaviour =  UIDynamicItemBehavior()
        itemBehaviour.allowsRotation = true
        itemBehaviour.friction = 0
        itemBehaviour.resistance = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.addObserver(self, forKeyPath: SettingsKeys.bounciness, options: NSKeyValueObservingOptions.New, context:nil)
        if let bounciness = (defaults.objectForKey(SettingsKeys.bounciness) ?? 1) as? Float {
            print(bounciness)
            itemBehaviour.elasticity = CGFloat(bounciness)
        }
        return itemBehaviour
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(itemBehavior)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let elasticity = change![(change?.indexForKey("new"))!].1 as? Float {
            itemBehavior.elasticity = CGFloat(elasticity)
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if (identifier != nil) {
            if identifier as? String == Boundaries.left {
                if itemBehavior.linearVelocityForItem(item).x < 20 {
                    itemBehavior.addLinearVelocity(CGPoint(x: 10, y: -10), forItem: item)
                }
            } else if identifier as? String == Boundaries.right {
                if itemBehavior.linearVelocityForItem(item).x > -20 {
                    itemBehavior.addLinearVelocity(CGPoint(x: -10, y: -10), forItem: item)
                }
            } else if identifier as? String == Boundaries.top {
                if itemBehavior.linearVelocityForItem(item).y > -20 && itemBehavior.linearVelocityForItem(item).y < 20 {
                    itemBehavior.addLinearVelocity(CGPoint(x: 0, y: 20), forItem: item)
                }
            } else if identifier as? String == Boundaries.slider {
                if itemBehavior.linearVelocityForItem(item).y > -20 && itemBehavior.linearVelocityForItem(item).y < 20 {
                    itemBehavior.addLinearVelocity(CGPoint(x: 0, y: -20), forItem: item)
                }
            }
            breakoutCollisionDelegate?.ballCollidedWithBlock(identifier!)
        }
    }
    
    func add(Block block: BlockView, ID id: NSCopying) {
        dynamicAnimator?.referenceView?.addSubview(block)
        collider.addBoundaryWithIdentifier(id, forPath: block.collisionBoundingPath)
    }
    
    func add(Ball ball: BallView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        itemBehavior.addItem(ball)
        itemBehavior.addLinearVelocity(CGPoint(x: Int(arc4random_uniform(400))-200,y: -200), forItem: ball)
    }
    
    func add(Slider slider: SliderView) {
        dynamicAnimator?.referenceView?.addSubview(slider)
        collider.addBoundaryWithIdentifier(Boundaries.slider, forPath: slider.collisionBoundingPath)
    }
    
    func remove(Block block: BlockView, ID id: NSCopying) {
        collider.removeBoundaryWithIdentifier(id)
        UIView.transitionWithView(block, duration: 0.7,
            options: .TransitionFlipFromBottom,
            animations: {
                block.alpha = 0
            },completion: { (success) -> Void in
                        block.removeFromSuperview()
        })
    }
    
    func remove(Ball ball: BallView) {
        ball.removeFromSuperview()
        itemBehavior.removeItem(ball)
        collider.removeItem(ball)
    }
    
    func remove(Slider slider: SliderView) {
        slider.removeFromSuperview()
        collider.removeBoundaryWithIdentifier(Boundaries.slider)
    }
    
    func replaceBoundaryWithFrame(frame: CGRect) {
        collider.removeBoundaryWithIdentifier(Boundaries.left)
        collider.removeBoundaryWithIdentifier(Boundaries.right)
        collider.removeBoundaryWithIdentifier(Boundaries.top)
        collider.addBoundaryWithIdentifier(Boundaries.left,
            fromPoint: CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height),
            toPoint: frame.origin)
        collider.addBoundaryWithIdentifier(Boundaries.right,
            fromPoint: frame.origin,
            toPoint: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y))
        collider.addBoundaryWithIdentifier(Boundaries.right,
            fromPoint: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y),
            toPoint: CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height))
    }
    
    func clear() {
        for item in collider.items {
            collider.removeItem(item)
        }
        for item in itemBehavior.items {
            itemBehavior.removeItem(item)
        }
        if let boundaries = collider.boundaryIdentifiers {
            for boundary in boundaries {
                collider.removeBoundaryWithIdentifier(boundary)
            }
        }
    }
}
