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
    static let segueToSearch = "Segue to search"
    static let segueImage = "Segue to image view"
}

enum detailsHeaders: String {
    case users = "Users"
    case urls = "Urls"
    case images = "Images"
    case hashtags = "Hashtags"
}

class TweetDetailsVC: UITableViewController {
    
    var sections: [Section] = []
    
    var images: [Int: UIImage] = [Int: UIImage]()
    
    var tweet: Tweet? {
        didSet{
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
            print(images)
            if let image = images[indexPath.row] {
                cell.imageView?.image = image
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let image = TweetModel.loadImageFromString(self.sections[indexPath.section].cells[indexPath.row])
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView?.image = image
                        self.images[indexPath.row] = image!
                        tableView.reloadData()
                    }
                })
            }
        } else {
            cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row]
        }
        return cell
    }
    
    var selectedItem: NSIndexPath?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = sections[indexPath.section]
        selectedItem = indexPath
        switch section.header {
        case .urls:
            UIApplication.sharedApplication().openURL(NSURL(string: section.cells[indexPath.row])!)
        case .hashtags,
            .users:
            performSegueWithIdentifier(TD_Constants.segueToSearch, sender: self)
        case .images:
            performSegueWithIdentifier(TD_Constants.segueImage, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sectionValue = sections[(selectedItem?.section)!].cells[(selectedItem?.row)!]
        if segue.identifier == TD_Constants.segueToSearch {
            if let destVc = segue.destinationViewController as? TweetsTVC {
                destVc.twitterQueryText = sectionValue
            }
        } else if segue.identifier == TD_Constants.segueImage {
            if let destVc = segue.destinationViewController as? ImageVC {
                destVc.imagePath = sectionValue
            }
        }
    }
}