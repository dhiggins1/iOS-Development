//
//  TweetCell.swift
//  TweeterTags
//
//  Created by student on 22/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var cellText: UITextView!
    
    var tweet: Tweet? {
        didSet{
            cellText.text = tweet?.text
        }
    }
}
