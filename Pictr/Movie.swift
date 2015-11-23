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
//        popularity = dictionary[TMDBClient.JSONResponseKeys.MoviePopularity] as! Double
        voteAverage = dictionary[TMDBClient.JSONResponseKeys.MovieVoteAverage] as! Double
        voteCount = dictionary[TMDBClient.JSONResponseKeys.MovieVoteCount] as! Int
        releaseDate = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String
        
//        if let releaseDateString = dictionary[TMDBClient.JSONResponseKeys.MovieReleaseDate] as? String {
//            
//            if releaseDateString.isEmpty == false {
//                releaseYear = releaseDateString.substringToIndex(releaseDateString.startIndex)
//            } else {
//                releaseYear = ""
//            }
//        }
    }
    
//    var fetchInProgress = false
//    
//    var didFetchImageData: Bool {
//        if let localURL = localURL {
//            if NSFileManager.defaultManager().fileExistsAtPath(localURL.path!) {
//                return true
//            }
//        }
//        return false
//    }
//    
//    var imageName: String? {
//        if let imageRemotePath = posterPath {
//            let url = NSURL(string: imageRemotePath)
//            if let imageName = url?.pathComponents?.last {
//                return imageName
//            }
//        }
//        return nil
//    }
//    
//    var localURL: NSURL? {
//        let url = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
//        if let imageName = imageName {
//            return url.URLByAppendingPathComponent(imageName)
//        }
//        return nil
//    }
//    
//    var imageData: NSData? {
//        var imageData: NSData? = nil
//        if let localURL = localURL {
//            if NSFileManager.defaultManager().fileExistsAtPath(localURL.path!) {
//                imageData = NSData(contentsOfURL: localURL)
//            }
//        }
//        return imageData
//    }
//    
//    func fetchImageData(completionHandler : (fetchComplete: Bool) -> Void) {
//        if didFetchImageData == false && fetchInProgress == false {
//            fetchInProgress = true
//            if let localURL = localURL {
//                if let imageRemotePath = posterPath {
//                    TMDBClient.sharedInstance().taskForGETImage("w185", filePath: imageRemotePath) { imageData, error in
//                        if error != nil {
//                            completionHandler(fetchComplete: false)
//                        } else {
//                            NSFileManager.defaultManager().createFileAtPath(localURL.path!, contents: imageData, attributes: nil)
//                        }
//                        completionHandler(fetchComplete: true)
//                    }
//                    self.fetchInProgress = false
//                }
//            }
//        }
//    }
    
    var posterImage: UIImage? {
        
        get {
            return TMDBClient.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set {
            TMDBClient.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }

    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBMovie objects */
    static func moviesFromResults(results: [[String : AnyObject]]) -> [Movie] {
        var movies = [Movie]()
        
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
}