//
//  PhotosViewController.swift
//  VirtualTourist_1
//
//  Created by Mehdi Salemi on 3/12/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate,  CLLocationManagerDelegate {

    // Mark : UI Elements
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBAction func newCollectionPressed(sender: AnyObject) {
    }
    
    // Mark : Main Variables
    var photos : [Photo]!
    var cordinates : CLLocationCoordinate2D!
    var pages : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.reloadData()
        self.mapView.delegate = self
        self.mapView.setCenterCoordinate(cordinates, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss:")
    }
    
    @IBAction func dismiss(sender:AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        mapView.setZoomByDelta(0.1, animated: true)
        print(pages)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoDetailCell
        
        let photo = photos[indexPath.row]
        cell.photoImageView.image = photo.image

        return cell
    }
}

extension MKMapView {
    func setZoomByDelta(delta: Double, animated: Bool) {
        var _region = region;
        var _span = region.span;
        _span.latitudeDelta *= delta;
        _span.longitudeDelta *= delta;
        _region.span = _span;
        
        setRegion(_region, animated: animated)
    }
}
