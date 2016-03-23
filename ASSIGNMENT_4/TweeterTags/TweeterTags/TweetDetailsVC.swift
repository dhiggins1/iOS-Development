//
//  TweetDetailsVC.swift
//  TweeterTags
//
//  Created by student on 23/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class Section {
    var header: detailsHeaders
    var cells: [String]
    init(header: detailsHeaders, cells: [String]) {
        self.header = header
        self.cells = cells
    }
    convenience init (header: detailsHeaders, keywordArray: [Tweet.IndexedKeyword]) {
        self.init(header: header, cells: [])
        cells = TweetModel.toStringArray(keywordArray)
    }
    convenience init (header: detailsHeaders, imageArray: [MediaItem]) {
        self.init(header: header, cells: [])
        cells = TweetModel.toStringArray(imageArray)
    }
}

struct TD_Constants {
    static let cellId = "TweetDetailsCell"
}

enum detailsHeaders: String {
    case users = "Users"
    case urls = "Urls"
    case images = "Images"
    case hashtags = "Hashtags"
}

class TweetDetailsVC: UITableViewController {
    
    var sections: [Section] = []
    
    var tweet: Tweet? {
        didSet{
            print(tweet?.media)
            self.title = "@\(tweet!.user.screenName)"
            if !(tweet!.media.isEmpty) {
                sections.append(Section(header: detailsHeaders.images, imageArray: tweet!.media))
            }
            if !(tweet!.urls.isEmpty) {
                sections.append(Section(header: detailsHeaders.urls, keywordArray: tweet!.urls))
            }
            if !(tweet!.hashtags.isEmpty) {
                sections.append(Section(header: detailsHeaders.hashtags, keywordArray: tweet!.hashtags))
            }
            if !(tweet!.userMentions.isEmpty) {
                sections.append(Section(header: detailsHeaders.users, keywordArray: tweet!.userMentions))
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.indices.last! + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.indices.last! + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header.rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TD_Constants.cellId, forIndexPath: indexPath)
        if sections[indexPath.section].header == .images {
            cell.imageView?.contentMode = UIViewContentMode.Center
//            cell.imageView?.clipsToBounds = true
//            cell.imageView?.frame = tableView.frame
            cell.imageView?.image = TweetModel.loadImageFromString(sections[indexPath.section].cells[indexPath.row])
        } else {
            cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row]
        }
        return cell
    }
}