//
//  TMDBConvenience.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Convenient Resource Methods

extension TMDBClient {
    
    func getNowPlayingMovies(completionHandler: (result: [[String : AnyObject]]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let task = taskForGETMethod(Methods.NowPlaying, parameters: nil) { JSONResult, error in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        return task
    }
    
    func getGenres(completionHandler: (result: [[String : AnyObject]]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let task = taskForGETMethod(Methods.MovieGenres, parameters: nil) { JSONResult, error in
        
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.GenreResults) as? [[String : AnyObject]] {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getGenres parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getGenres"]))
                }
            }
        }
        return task
    }
    
    func getMoviesForGenre(genreID: Int, completionHandler: (result: [[String : AnyObject]]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        var mutableMethod : String = Methods.MoviesByGenre
        mutableMethod = TMDBClient.subtituteKeyInMethod(mutableMethod, key: TMDBClient.JSONResponseKeys.GenreID, value: String(genreID))!
        
        let task = taskForGETMethod(mutableMethod, parameters: nil) { JSONResult, error in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForGenre parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForGenre"]))
                }
            }
        }
        return task
    }
    
    func getMoviesForSearchString(searchString: String, completionHandler: (result: [[String : AnyObject]]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters) { JSONResult, error in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
    }
}