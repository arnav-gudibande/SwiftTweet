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
    public func pullImageFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main()) {
                (response: URLResponse?, data: Data?, error: NSError?) -> Void in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}

class TimeLineTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [JSON] = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
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
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray()
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
