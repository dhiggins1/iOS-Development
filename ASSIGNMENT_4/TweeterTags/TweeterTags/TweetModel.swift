//
//  TweetModel.swift
//  TweeterTags
//
//  Created by student on 22/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

extension User {
    func getProfileImage() -> UIImage? {
        if let data = NSData(contentsOfURL: self.profileImageURL!) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}

extension Tweet {
    func getFormattedText() -> NSMutableAttributedString {
        let colouredString = NSMutableAttributedString(string: self.text)
        addColourToKeywords(colouredString, ranges: self.userMentions, color: UIColor.greenColor())
        addColourToKeywords(colouredString, ranges: self.urls, color: UIColor.redColor())
        addColourToKeywords(colouredString, ranges: self.hashtags, color: UIColor.blueColor())
        return colouredString
    }
    private func addColourToKeywords(string: NSMutableAttributedString, ranges: [IndexedKeyword], color: UIColor) -> NSMutableAttributedString {
        for var index in ranges {
            string.addAttribute(NSForegroundColorAttributeName, value: color, range: index.nsrange)
        }
        return string
    }
}