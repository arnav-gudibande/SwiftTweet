//
//  TimeLineTableViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SwifteriOS

class TimeLineTableViewController: UITableViewController {
    
    var tweets: [JSONValue] = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
        
    }

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        self.title = "Timeline"
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = tweets[indexPath.row]["text"].string
        
        return cell
    }

}
