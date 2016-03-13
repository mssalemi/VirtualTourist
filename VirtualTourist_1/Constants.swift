//
//  Constants.swift
//  VirtualTourist_1
//
//  Created by Mehdi Salemi on 3/11/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Defaults {
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let LatitudeDelta = "latitudeDelta"
        static let LongitudeDelta = "longitudeDelta"
    }
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/?"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let latitude = "lat"
        static let longitude = "lon"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let Extras = "extras"
        static let PerPage = "per_page"
        static let Page = "page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "198a0bf44842f55e073db26b0491efd2"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let PhotoFromCordinateMethod = "flickr.photos.search"
        static let MediumURL = "url_m"
        static let PerPage = "12"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
}