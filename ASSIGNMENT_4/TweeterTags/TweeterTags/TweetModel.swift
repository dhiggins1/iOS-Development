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
        return TweetModel.loadImage(self.profileImageURL!)
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

class TweetModel: NSObject {
    
    static func loadImage(url: NSURL) -> UIImage? {
        if let data = NSData(contentsOfURL: url) {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
    static func loadImageFromString(stringUrl: String) -> UIImage? {
        print("load image: \(stringUrl)")
        return loadImage(NSURL(string: stringUrl)!)
    }
    
    static func toStringArray(keyWordArray: [Tweet.IndexedKeyword]) -> [String] {
        var retVal: [String] = []
        for item in keyWordArray {
            retVal.append(item.keyword)
        }
        return retVal
    }
    
    static func toStringArray(mediaArray: [MediaItem]) -> [String] {
        var retVal: [String] = []
        for item in mediaArray {
            retVal.append(String(item.url))
        }
        return retVal
    }
}