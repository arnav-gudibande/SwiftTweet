//
//  geoTweetViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/13/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import MapKit
import SwifteriOS

class geoTweetViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var geoTags: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(geoTags)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
