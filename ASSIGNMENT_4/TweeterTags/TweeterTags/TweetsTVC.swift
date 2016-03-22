//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by student on 22/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

struct Constants {
    static let tableCell = "TweetCell"
}

class TweetsTVC: UITableViewController {
    var tweets = [[Tweet]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var twitterQueryText: String? = "#ucd" {
        didSet {
            tweets.removeAll()
            refresh()
            self.title = "Results for \(twitterQueryText!) search"
        }
    }
    
    private func refresh() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let twitterRequest = TwitterRequest(search: self.twitterQueryText!, count: 8)
            twitterRequest.fetchTweets({ (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        self.tweets.insert(newTweets, atIndex: 0)
                    }
                }
            })
        })
    }
    
    override func viewDidLoad() {
        refresh()
        self.title = "Results for \(twitterQueryText!) search"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.tableCell, forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }

}
