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
    public func imageFromUrl(_ urlString: String) {
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

class ViewController: UIViewController, SFSafariViewControllerDelegate, CLLocationManagerDelegate {
    
    var swifter: Swifter?
    var userIDG: Int?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    var geo: String?
    var woeid: Int?
    var arrHashtags: Array<String> = []
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followersNumber: UILabel!
    @IBOutlet weak var followingNumber: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tweetsNumber: UILabel!
    
    @IBAction func timeLineButtonPressed(_ sender: AnyObject) {
        self.swifter!.getStatusesHomeTimelineWithCount(20, success: { statuses in
            let timeLineTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "TimeLineTableViewController") as! TimeLineTableViewController
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
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) {
            granted, error in
            self.setSwifter()
        }
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        lat = locationManager.location?.coordinate.latitude
        lon = locationManager.location?.coordinate.longitude
        geo = "\(lat!)" + "," + "\(lon!)" + "," + "10mi"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error retrieving location")
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func setSwifter() {
        let accounts: [ACAccount] = {
            let twitterAccountType = ACAccountStore().accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
            return (ACAccountStore().accounts(with: twitterAccountType) as? [ACAccount])!
        }()
        
        swifter = Swifter(account: accounts[0])
        
        DispatchQueue.main.async {
            self.setProfile(accounts)
            self.setTrending()
        }
        
    }
    
    func setProfile(_ accounts: [ACAccount]) {
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
    
    func setTrending() {
        let failureHandler: ((NSError) -> Void) = { error in
            
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        self.swifter!.getTrendsClosestWithLat(lat!, long: lon!, success: { json in
            
            guard let trend = json else { return }
            self.woeid = trend[0]["woeid"].integer
            
            self.swifter?.getTrendsPlaceWithWOEID(String(self.woeid!), success: { trends in
                guard let trendingHashtags = trends else { return }
                
                for i in 0...25 {
                    self.arrHashtags.append(trendingHashtags[0]["trends"][i]["name"].string!)
                }
                print(self.geo!)
                
                for ix in self.arrHashtags {
                    
                    self.swifter!.getSearchTweetsWithQuery(ix, count: 2, success: { (statuses, searchMetadata) in
                        
                        guard let trendingTweets = statuses else { return }
                        
                        if trendingTweets.count>0 {
                            for i in 0..<trendingTweets.count {
                                print(trendingTweets[i]["text"])
                                print(trendingTweets[i]["coordinates"])
                                print(trendingTweets[i]["user"]["location"])
                            }
                        }
                        
                    },failure: failureHandler)

                }

            }, failure: failureHandler)
            
        }, failure: failureHandler)
        
        
       
        
        
    }

    
    func alertWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
