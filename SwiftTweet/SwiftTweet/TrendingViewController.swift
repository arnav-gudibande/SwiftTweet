//
//  TrendingViewController.swift
//  SwiftTweet
//
//  Created by Arnav Gudibande on 7/10/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import MapKit
import SwifteriOS

class TrendingViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var trendingMap: MKMapView!
    
    var tweets: [JSONValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        return nil
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
