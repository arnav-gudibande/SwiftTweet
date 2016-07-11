//
//  TimeLineTableViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SwifteriOS

extension UIImageView {
    public func pullImageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
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
        print(tweets)
        cell.TweetFullName.text = tweets[indexPath.row]["user"]["name"].string
        cell.TweetUserName.text = "@" + tweets[indexPath.row]["user"]["screen_name"].string!
        let tweetURL = tweets[indexPath.row]["user"]["profile_image_url"].string
        cell.TweetProfilePic.pullImageFromUrl(tweetURL!)
        let tweetColor = tweets[indexPath.row]["user"]["profile_background_color"].string
        cell.TweetAccent.backgroundColor = hexStringToUIColor(tweetColor!)
        let arrT = tweets[indexPath.row]["extended_entities"]["media"].array
        if(arrT?.endIndex>=1){
            let url = arrT![0]["media_url"].string
            cell.TweetImage.pullImageFromUrl(url!)
        }
        cell.TweetBody.numberOfLines = 0
        cell.TweetBody.text = tweets[indexPath.row]["text"].string
        return cell
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
