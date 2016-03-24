//
//  HistoryVC.swift
//  TweeterTags
//
//  Created by student on 24/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

extension Constants {
    static let historyCell = "History Cell"
}

class HistoryVC: UITableViewController {
    
    var searches : [String]? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(Constants.userDefaultsSearches) as? [String]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searches != nil) {
            return searches!.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.historyCell, forIndexPath: indexPath)
        cell.textLabel?.text = searches![indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? TweetsTVC {
            if let senderCell = sender as? UITableViewCell {
                destVC.twitterQueryText = senderCell.textLabel?.text
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
}
