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

class geoTweetViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var hashtagTableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var geoTags: [JSON] = []
    var geoCoords = ["hashtag":[0.0,0.0]]
    var currentLoc: Array<Double> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(currentLoc[0]), longitude: CLLocationDegrees(currentLoc[1]))
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        mapView.setRegion(theRegion, animated: true)
        
        for (hashtags, coordinates) in geoCoords {
            let anotation = MKPointAnnotation()
            let annotationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinates[0]), longitude: CLLocationDegrees(coordinates[1]))
            anotation.coordinate = annotationCoordinate
            anotation.title = hashtags
            anotation.subtitle = "Trending on Twitter"
            mapView.addAnnotation(anotation)
        }

        self.hashtagTableView.delegate = self
        self.hashtagTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagTrendingViewCell") as! HashtagTrendingTableViewCell
        let name = geoTags[0]["trends"][indexPath.row]["name"].string
        if geoTags[0]["trends"][indexPath.row]["tweet_volume"] != nil {
            let volume = geoTags[0]["trends"][indexPath.row]["tweet_volume"].integer
            cell.tweetVolume.text = String(volume!) + " Tweets"
        }
        cell.trendingLabel.text = name
        return cell
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
