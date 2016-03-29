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
    static let userDefaultsSearches = "past user searches"
}

enum Segues: String {
    case tweetDetailsSegue = "TweetDetailsSegue"
    init?(_ segue: UIStoryboardSegue) {
        self.init(rawValue: segue.identifier!)
    }
}

class TweetsTVC: UITableViewController, UITextFieldDelegate {
    var tweets = [[Tweet]]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var twitterQueryTextField: UITextField! {
        didSet {
            twitterQueryTextField.delegate = self
        }
    }
    
    var twitterQueryText: String? = "#ucd" {
        didSet {
            let defaults = NSUserDefaults.standardUserDefaults()
            var newSearchArray = [String]()
            if let searchArray = defaults.objectForKey(Constants.userDefaultsSearches) as? [String] {
                newSearchArray = searchArray
                if newSearchArray.count >= 100 {
                    newSearchArray.popLast()
                }
            }
            if !newSearchArray.isEmpty && !(twitterQueryText! == newSearchArray.first!) {
                newSearchArray = [twitterQueryText!] + newSearchArray
            }
            print(newSearchArray)
            defaults.setObject(newSearchArray, forKey: Constants.userDefaultsSearches)
            tweets.removeAll()
            refresh()
            self.title = "Results for \(twitterQueryText!) search"
        }
    }

    private func refresh() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let twitterRequest = TwitterRequest(search: self.twitterQueryText!)
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
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let image = cell.tweet?.user.getProfileImage() {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.profileImage.image = image
                }
            }
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let colouredText = cell.tweet?.getFormattedText()
            dispatch_async(dispatch_get_main_queue()) {
                cell.cellText.attributedText = colouredText
            }
        })
        return cell
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        twitterQueryText = textField.text!
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController!
        }
        switch Segues(segue)! {
        case .tweetDetailsSegue:
            if let senderView = sender as? TweetCell {
                if let destinationVC = destinationVC as? TweetDetailsVC {
                    destinationVC.tweet = senderView.tweet
                }
            }
        }
    }

}
