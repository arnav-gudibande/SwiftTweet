//
//  geoTweetViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/13/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import MapKit

class geoTweetViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapV: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
