//
//  ViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SwifteriOS
import Accounts

class ViewController: UIViewController {
    
    var swifter: Swifter?

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
            granted, error in
            self.setSwifter()
        }
    }
    
    func setSwifter() {
        let accounts: [ACAccount] = {
            let twitterAccountType = ACAccountStore().accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            return (ACAccountStore().accountsWithAccountType(twitterAccountType) as? [ACAccount])!
        }()
        
        swifter = Swifter(account: accounts[0])
        setProfile(accounts)
    }
    
    func setProfile(accounts: [ACAccount]) {
        print(accounts[0].userFullName)
        self.fullName.text = accounts[0].userFullName
        self.userName.text = "@" + accounts[0].username
        let userName = accounts[0].username
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        self.swifter!.getStatusesHomeTimelineWithCount(20, success: { statuses in
            
            let timeLineTableViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TimeLineTableViewController") as! TimeLineTableViewController
            guard let tweets = statuses else { return }
            timeLineTableViewController.tweets = tweets
            self.navigationController?.pushViewController(timeLineTableViewController, animated: true)
        })
    }

}

