//
//  AppDelegate.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/3/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SwifteriOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        Swifter.handleOpenURL(url)
        
        return true
    }
    
}

