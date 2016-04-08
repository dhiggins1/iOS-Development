//
//  FirstViewController.swift
//  Breakout
//
//  Created by student on 04/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class BreakoutVC: UIViewController, UIDynamicAnimatorDelegate, BreakoutCollisionDelegate, UIAlertViewDelegate {
    
    private var blocks = [Int: BlockView]()
    
    private var balls = [BallView]()
    
    private var slider: SliderView?
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        print(sender.locationInView(gameView))
        let closestBall = BreakoutModel.getClosestBall(atPoint: sender.locationInView(gameView), forBalls: balls)
        behavior.itemBehavior.addLinearVelocity(CGPoint(x: 0, y: -100), forItem: closestBall)
    }
    
    @IBAction func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        var destx = slider!.center.x + translation.x
        let halfSliderWidth = slider!.bounds.width / 2
        if destx - halfSliderWidth < gameView.bounds.origin.x {
            destx = gameView.bounds.origin.x + halfSliderWidth
        } else if destx + halfSliderWidth > gameView.bounds.width {
            destx = gameView.bounds.width - halfSliderWidth
        }
        slider!.center = CGPoint(x:destx, y:slider!.center.y)
        behavior.remove(Slider: slider!)
        behavior.add(Slider: slider!)
        sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBOutlet weak var gameView: UIView!
    private lazy var behavior: BreakoutBehaviour = {
        var behavior = BreakoutBehaviour()
        behavior.breakoutCollisionDelegate = self
        return behavior
    }()
    
    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self.gameView)
        animator.addBehavior(self.behavior)
        return animator
    }()
    
    private var blockWidth: CGFloat {
        get {
            return self.gameView.bounds.width / 5;
        }
    }
    
    private var blockHeight: CGFloat = 15
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animator.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
    }
    
    override func viewDidDisappear(animated: Bool) {
        clear()
    }
    
    func clear() {slider = nil
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
        behavior.clear()
        blocks.removeAll()
        balls.removeAll()
    }
    
    func refresh() {
        clear()
        behavior.replaceBoundaryWithFrame(gameView.bounds)
        addBlocks()
        addSlider()
        addBalls()
    }

    func addBlocks() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let numBlocks = (defaults.objectForKey(SettingsKeys.blocks) ?? 25) as? Int {
            let numRows = numBlocks / 5;
            for j in 0..<numRows {
                for i in 0...4 {
                    var frame = CGRect()
                    frame.origin = CGPoint(x: CGFloat(i) * blockWidth, y: CGFloat(j) * blockHeight)
                    frame.size = CGSize(width: blockWidth - 1, height: blockHeight - 1)
                    let block = BlockView(frame: frame)
                    let id = blocks.count
                    blocks[id]=block
                    behavior.add(Block: block, ID: id)
                }
            }
        }
    }
    
    func addBalls() {
        let ballWidth = gameView.bounds.width / 40;
        let ballHeight = ballWidth;
        let defaults = NSUserDefaults.standardUserDefaults()
        if let numBalls = (defaults.objectForKey(SettingsKeys.balls) ?? 2) as? Int {
            for _ in 1...numBalls {
                var frame = CGRect()
                let random_num = (CGFloat(random()) / CGFloat(RAND_MAX)) * gameView.bounds.width
                frame.origin = CGPoint(x: random_num, y: gameView.center.y)
                frame.size = CGSize(width: ballWidth, height: ballHeight)
                let ball = BallView(frame: frame)
                balls.append(ball)
                behavior.add(Ball: ball)
            }
        }
    }
    
    func addSlider() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let sliderDiv: CGFloat = CGFloat(((defaults.objectForKey(SettingsKeys.sliderSize) ?? 0.25) as? Float)!)
        let sliderWidth: CGFloat = gameView.bounds.width * sliderDiv
        let sliderHeight = CGFloat(10)
        var frame = CGRect()
        frame.origin = CGPoint(x: gameView.center.x - (sliderWidth / 2), y: gameView.bounds.height - sliderHeight)
        frame.size = CGSize(width: sliderWidth, height: sliderHeight)
        slider = SliderView(frame: frame)
        behavior.add(Slider: slider!)
    }
    
    func ballCollidedWithBlock(blockId: NSCopying) {
        if let id = blockId as? Int {
            if id >= 0 && blocks.keys.contains(id) {
                behavior.remove(Block: blocks[id]!, ID: id)
                blocks.removeValueForKey(id)
            }
        }
        if blocks.count == 0 {
            let alert = UIAlertController(title: "You Win", message: "You broke all the blocks", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Another Game!", style: UIAlertActionStyle.Default, handler: reactToAction))
            self.presentViewController(alert, animated: true) {}
        }
    }
    
    func ballNotInView(ball: BallView) {
        behavior.remove(Ball: ball)
        if let index = balls.indexOf(ball) {
            balls.removeAtIndex(index)
        }
        if balls.count == 0 {
            let alert = UIAlertController(title: "Game Over", message: "All the Balls Left the Field", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Another Game!", style: UIAlertActionStyle.Default, handler: reactToAction))
            self.presentViewController(alert, animated: true) {}
        }
    }
    
    func reactToAction (action: UIAlertAction) {
        refresh()
    }
}
