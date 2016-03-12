//
//  Pin.swift
//  VirtualTourist_1
//
//  Created by Mehdi Salemi on 3/11/16.
//  Copyright © 2016 MxMd. All rights reserved.
//

import Foundation
import CoreData

class Pin : NSManagedObject {
    
    @NSManaged var longitude : Double
    @NSManaged var latitude : Double
    
    // Mark : Core Data Init
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Mark : Pin Init
    init(lat : Double, long : Double, context : NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        latitude = lat
        longitude = long
    }
    
}