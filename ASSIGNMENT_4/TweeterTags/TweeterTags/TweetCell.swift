//
//  TweetCell.swift
//  TweeterTags
//
//  Created by student on 22/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit



class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var cellText: UILabel!
    
    var tweet: Tweet? {
        didSet{
            cellText.text = tweet?.text
            screenName.text = "@\(tweet!.user.screenName!) (\(tweet!.user.name!))"
            date.text = "\(tweet!.created)"
        }
    }
}
