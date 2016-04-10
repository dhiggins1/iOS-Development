//
//  TopScoresVC.swift
//  Breakout
//
//  Created by student on 10/04/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

extension Constants {
    static let topScoresCell = "topScoresCell"
}

class TopScoresVC: UITableViewController {
    
    private var topScores = [Int]()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topScores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.topScoresCell, forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.row):   \(topScores[indexPath.row])"
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let scores = defaults.objectForKey(SettingsKeys.topScores) as? Array<Int> {
            topScores = scores
            topScores = topScores.sort({ $0 > $1 })
        }
        tableView.reloadData()
    }
}
