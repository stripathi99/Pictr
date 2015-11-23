//
//  TMDBMovie.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//
import Foundation
import UIKit

class Movie {

    var title = ""
    var id: Int64 = 0
    var posterPath: String? = nil
    var releaseDate: String? = nil
    var overview: String? = nil
    var voteAverage: Double = 0.0
    var voteCount: Int = 0
    //var popularity: Double = 0
    
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        id = Int64(dictionary[TMDBClient.JSONResponseKeys.MovieID] as! Int)
        posterPath = dictionary[TMDBClient.JSONResponseKeys.MoviePosterPath] as? String
        overview = dictionary[TMDBClient.JSONResponseKeys.MovieOverview] as? String
        voteAverage = dictionary[TMDBClient.JSONResponseKeys.MovieVoteAverage] as! Double
        voteCount = dictionary[TMDBClient.JSONResponseKeys.MovieVoteCount] as! Int
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
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