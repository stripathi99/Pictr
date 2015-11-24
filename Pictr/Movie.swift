//
//  TMDBMovie.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import CoreData

class Movie: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var title: String
    @NSManaged var posterPath: String?
    @NSManaged var releaseDate: String?
    @NSManaged var overview: String?
    @NSManaged var voteAverage: NSNumber?
    @NSManaged var voteCount: NSNumber?
    
    @NSManaged var isWatched: Bool
    @NSManaged var isFavorite: Bool
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        id = dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
        overview = dictionary[TMDBClient.JSONResponseKeys.MovieOverview] as? String
        voteAverage = dictionary[TMDBClient.JSONResponseKeys.MovieVoteAverage] as? Double
        voteCount = dictionary[TMDBClient.JSONResponseKeys.MovieVoteCount] as? Int
        
        isWatched = false
        isFavorite = false
    }
    
    var posterImage: UIImage? {
        get {
            return TMDBClient.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set {
            TMDBClient.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }
}