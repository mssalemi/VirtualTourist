//
//  FlickrClient.swift
//  VT_PracticeFlickrCollectionVIew
//
//  Created by Mehdi Salemi on 3/12/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData


class FlickrClient : NSObject {
    
    // Mark : Shared Instance
    private static var sharedInstance = FlickrClient()
    
    class func sharedClient() -> FlickrClient {
        return sharedInstance
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override init(){
        super.init()
    }
    
    func getPhotos(lat: Double, long:Double, handler : (photoArray : [Photo], cordinates : CLLocationCoordinate2D, page : Int) -> Void, random : Bool, pages : Int) {
        
        print("Starting Request")
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: createURL(long, lat: lat, random:  random, numOfPages: pages))
        let request = NSURLRequest(URL: url!)
        print(url!)
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print(parsedResult)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Cannot create dictionary")
                return
            }
            print(photosDictionary["pages"])
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                print("Cannot find keys '\(Constants.FlickrResponseKeys.Photos)' and '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            print(photoArray)
            
            var photos = [Photo]()
            
            print("Going Through Dictionary getting the items we need")
            for photo in photoArray {
                let title = photo["title"] as! String
                // TODO : Set File Path ?!?
                let newPhoto = Photo(title: title, filePath: "FilePath", context: self.sharedContext)
                // TODO : Set the Image a different way !
                newPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(string: photo["url_m"] as! String)!)!)
                photos.append(newPhoto)
                CoreDataStackManager.sharedInstance().saveContext()
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                let cord = CLLocationCoordinate2DMake(lat, long)
                handler(photoArray: photos, cordinates: cord, page: photosDictionary["pages"] as! Int)
            }
        }
        task.resume()
    }
    
    private func createURL(long: Double, lat: Double, random:Bool, numOfPages : Int) -> String{
        var urlString = Constants.Flickr.APIBaseURL
        urlString += Constants.FlickrParameterKeys.Method + "=" + Constants.FlickrParameterValues.PhotoFromCordinateMethod
        urlString += "&" + Constants.FlickrParameterKeys.APIKey + "=" + Constants.FlickrParameterValues.APIKey
        urlString += "&" + Constants.FlickrParameterKeys.latitude + "=\(lat)"
        urlString += "&" + Constants.FlickrParameterKeys.longitude + "=\(long)"
        urlString += "&" + Constants.FlickrParameterKeys.Format + "=" + Constants.FlickrParameterValues.ResponseFormat
        urlString += "&" + Constants.FlickrParameterKeys.NoJSONCallback + "=" + Constants.FlickrParameterValues.DisableJSONCallback
        urlString += "&" + Constants.FlickrParameterKeys.Extras + "=" + Constants.FlickrParameterValues.MediumURL
        urlString += "&" + Constants.FlickrParameterKeys.PerPage + "=" + Constants.FlickrParameterValues.PerPage
        
        if random {
            urlString += "&" + Constants.FlickrParameterKeys.Page + "=" + "\(Int(arc4random_uniform(UInt32(numOfPages))))"
        }
        
        return urlString
    }
}