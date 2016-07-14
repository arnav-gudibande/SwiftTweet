//
//  ViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwifteriOS
import MapKit
import SafariServices
import CoreLocation

extension UIImageView {
    public func imageFromUrl(urlString: String) {
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

class ViewController: UIViewController, SFSafariViewControllerDelegate, CLLocationManagerDelegate {
    
    var swifter: Swifter?
    var userIDG: Int?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    var geo: String?
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followersNumber: UILabel!
    @IBOutlet weak var followingNumber: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsNumber: UILabel!
    
    @IBAction func timeLineButtonPressed(sender: AnyObject) {
        self.swifter!.getStatusesHomeTimelineWithCount(20, success: { statuses in
            let timeLineTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TimeLineTableViewController") as! TimeLineTableViewController
            guard let tweets = statuses else { return }
            timeLineTableViewController.tweets = tweets
            self.navigationController?.pushViewController(timeLineTableViewController, animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            self.setSwifter()
        }
        self.setLoc()
    }
    
    func setLoc() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]!) {
        var locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print("Error retrieving location")
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func setSwifter() {
        let accounts: [ACAccount] = {
            let twitterAccountType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            return (ACAccountStore().accountsWithAccountType(twitterAccountType) as? [ACAccount])!
        }()
        
        swifter = Swifter(account: accounts[0])
        
        dispatch_async(dispatch_get_main_queue()) {
            self.setProfile(accounts)
        }
        
    }
    
    func setProfile(accounts: [ACAccount]) {
        self.fullName.text = accounts[0].userFullName
        self.userName.text = "@" + accounts[0].username
        let userName = accounts[0].username
        self.profileBanner.layer.zPosition = -1;
        
        let failureHandler: ((NSError) -> Void) = { error in
            
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter!.getUsersShowWithScreenName(userName!, success: { json in
            
            guard let url = json!["profile_image_url"]!.string else { return }
            self.profilePicture.imageFromUrl(url)
            
            guard let url2 = json!["profile_banner_url"]!.string else { return }
            self.profileBanner.imageFromUrl(url2)
            
            guard let followers = json!["followers_count"]!.integer else {return}
            self.followersNumber.text = String(followers)
            
            guard let friends = json!["friends_count"]!.integer else { return }
            self.followingNumber.text = String(friends)
            
            guard let des = json!["description"]!.string else { return }
            self.descriptionLabel.text = des
            
            guard let Bc = json!["profile_background_color"]!.string else { return }
            self.descriptionLabel.textColor = self.hexStringToUIColor(Bc)
            
            guard let tN = json!["statuses_count"]!.integer else { return }
            self.tweetsNumber.text = String(tN)
            
            guard let userID = json!["id_str"]!.string else { return }
            self.userIDG = Int(userID)
            
            }, failure: failureHandler)
        
    }

    
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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