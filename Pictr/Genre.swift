//
//  TMDBGenre.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import Foundation
import CoreData

class Genre: NSManagedObject {
    
    @NSManaged var id: NSNumber
    @NSManaged var name: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = dictionary[TMDBClient.JSONResponseKeys.GenreID] as! Int
        self.name = dictionary[TMDBClient.JSONResponseKeys.GenreName] as! String
    }
}