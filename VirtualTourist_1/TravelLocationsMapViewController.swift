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
import CoreData

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate {

    // Mark: UI Elements
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Mark: Vairiables
    var startSaving : Bool!
    var firstTimeOpening : Bool!
    var allPins = [Pin]()
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    // Mark: View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        startSaving = false
        
        if NSUserDefaults.standardUserDefaults().objectForKey(Constants.Defaults.Latitude) == nil {
            firstTimeOpening = true
        } else {
            firstTimeOpening = false
        }
        
        mapView.delegate = self
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: "addPin:")
        mapView.addGestureRecognizer(longPressedGesture)
        
        allPins = fetchAllPins()
        for pin in allPins {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = pin.latitude
            annotation.coordinate.longitude = pin.longitude
            annotation.title = "\(pin.latitude),\(pin.longitude)"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if firstTimeOpening == false {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.goToLastLocation()
            })
        } else {
            startSaving = true
        }
    }
    
    // Mark: Map View Functions
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveLastlocation(mapView.region.center, lastZoom: mapView.region.span)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(view.annotation?.coordinate)
        
        activityIndicator.startAnimating()
        
        func completionHandler(photoArray : [Photo], cordinates : CLLocationCoordinate2D, page : Int) {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PhotosViewController") as! PhotosViewController
            controller.photos = photoArray
            controller.cordinates = cordinates
            controller.pages = page
            self.navigationController!.pushViewController(controller, animated: true)
            self.activityIndicator.stopAnimating()
        }
        
        let lat = (view.annotation?.coordinate.latitude)! as Double
        let long = (view.annotation?.coordinate.longitude)! as Double
        FlickrClient.sharedClient().getPhotos(lat, long: long, handler: completionHandler, random: false, pages: 1)
    }
    
    // Core Data Functions
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllActors(): \(error)")
            return [Pin]()
        }
    }
    
    // Mark : Helping Functions
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
    
    @IBAction func addPin(gestureRecognizer : UIGestureRecognizer){
        let pointOnMap = gestureRecognizer.locationInView(mapView)
        let cordinate = self.mapView.convertPoint(pointOnMap, toCoordinateFromView: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = cordinate
        annotation.title = "\(cordinate.latitude),\(cordinate.longitude)"
        self.mapView.addAnnotation(annotation)
        
        let newPin = Pin(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude, context: self.sharedContext)
        self.allPins.append(newPin)
        CoreDataStackManager.sharedInstance().saveContext()
    }

}


