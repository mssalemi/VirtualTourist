//
//  Photo.swift
//  VT_PracticeFlickrCollectionVIew
//
//  Created by Mehdi Salemi on 3/10/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Photo : NSManagedObject {
    @NSManaged var title : String!
    @NSManaged var imagePath : String!
    var image : UIImage!
    
    // Mark : Core Data Init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Mark : Pin Init
    init(title : String, filePath: String, context : NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.title = title
        self.imagePath = filePath
        getImage()
    }
    
    func getImage(){
        var imageData : NSData!
        if let imageData = NSUserDefaults.standardUserDefaults().objectForKey(title) as? NSData {
                    self.image = UIImage(data: imageData)
        } else {
            print("Couldn't save image.")
        }
        print("Attempt to set image complete")
    }
    
}