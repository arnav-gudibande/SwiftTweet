//
//  TimeLineTableViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SwifteriOS

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class TimeLineTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [JSONValue] = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as! TweetTableViewCell
        
        cell.TweetFullName.text = tweets[indexPath.row]["user"]["name"].string
        cell.TweetUserName.text = "@" + tweets[indexPath.row]["user"]["screen_name"].string!
        let tweetURL = tweets[indexPath.row]["user"]["profile_image_url"].string
        cell.TweetProfilePic.imageFromUrl(tweetURL!)
        cell.TweetBody.numberOfLines = 0
        cell.TweetBody.text = tweets[indexPath.row]["text"].string
        return cell
    }

}
