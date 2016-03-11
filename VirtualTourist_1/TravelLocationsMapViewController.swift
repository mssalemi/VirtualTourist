//
//  TravelLocationsMapViewController.swift
//  VirtualTourist_1
//
//  Created by Mehdi Salemi on 3/11/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {

    // Mark: UI Elements
    @IBOutlet weak var mapView: MKMapView!
    
    // Mark: Vairiables
    var startSaving : Bool!
    
    // Mark: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        startSaving = false
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.goToLastLocation()
        })
    }
    
    // Mark: Map View Functions
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveLastlocation(mapView.region.center, lastZoom: mapView.region.span)
    }
    
    func saveLastlocation(lastLocation : CLLocationCoordinate2D, lastZoom : MKCoordinateSpan){
        if startSaving! {
            NSUserDefaults.standardUserDefaults().setObject(lastLocation.latitude, forKey: Constants.Defaults.Latitude)
            NSUserDefaults.standardUserDefaults().setObject(lastLocation.longitude, forKey: Constants.Defaults.Longitude)
            NSUserDefaults.standardUserDefaults().setObject(lastZoom.latitudeDelta, forKey: Constants.Defaults.LatitudeDelta)
            NSUserDefaults.standardUserDefaults().setObject(lastZoom.longitudeDelta, forKey: Constants.Defaults.LongitudeDelta)
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func goToLastLocation(){
        let lat = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Defaults.Latitude)! as? Double
        let long = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Defaults.Longitude)! as? Double
        let latDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Defaults.LatitudeDelta)! as? Double
        let longDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Defaults.LongitudeDelta)! as? Double
        
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: lat!, longitude: long!), MKCoordinateSpanMake(latDelta!, longDelta!))
        mapView.setRegion(region, animated: false)
        startSaving = true
    }
    
    
}

