//
//  SecondViewController.swift
//  Breakout
//
//  Created by student on 04/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

struct SettingsKeys {
    static let balls = "numOfBalls"
    static let blocks = "numOfBlocks"
    static let bounciness = "bouncinessOfBalls"
    static let sliderSize = "sliderSize"
    static let topScores = "topScores"
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var numBallsControl: UISegmentedControl!
    @IBAction func numBallsChanged(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!), forKey: SettingsKeys.balls)
    }
    
    @IBOutlet weak var numBlocksControl: UIStepper!
    @IBAction func numBlocksChanged(sender: UIStepper) {
        numBlocksLabel.text = Int(sender.value).description
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sender.value), forKey: SettingsKeys.blocks)
    }
    
    @IBOutlet weak var bouncinessControl: UISlider!
    @IBAction func bouncinessChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.value, forKey: SettingsKeys.bounciness)
    }
    
    @IBOutlet weak var sliderSize: UISlider!
    @IBAction func sliderSizeChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(sender.value, forKey: SettingsKeys.sliderSize)
    }
    
    @IBOutlet weak var numBlocksLabel: UILabel!
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let numBlocks = defaults.objectForKey(SettingsKeys.blocks) as? Int {
            numBlocksControl.value = Double(numBlocks);
            numBlocksLabel.text = numBlocks.description
        }
        if let numBalls = defaults.objectForKey(SettingsKeys.balls) as? Int {
            numBallsControl.selectedSegmentIndex = numBalls - 1
        }
        if let bounciness = defaults.objectForKey(SettingsKeys.bounciness) as? Float {
            bouncinessControl.value = bounciness
        }
        if let size = defaults.objectForKey(SettingsKeys.sliderSize) as? Float {
            sliderSize.value = size
        }
    }

}

