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
    
    func getNowPlayingMovies(completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let task = taskForGETMethod(Methods.NowPlaying, parameters: nil) { JSONResult, error in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                print("JSONResult - \(JSONResult)")
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        return task
    }
    
    func getGenres(completionHandler: (result: [TMDBGenre]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let task = taskForGETMethod(Methods.MovieGenres, parameters: nil) { JSONResult, error in
        
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                print("getGenres JSONResult - \(JSONResult)")
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.GenreResults) as? [[String : AnyObject]] {
                    
                    let genres = TMDBGenre.genresFromResults(results)
                    completionHandler(result: genres, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getGenres parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getGenres"]))
                }
            }
        }
        return task
    }
    
    func getMoviesForGenre(genre: Int, completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        let parameters = [TMDBClient.ParameterKeys.GenreID: genre]
        
        let task = taskForGETMethod(Methods.MoviesByGenre, parameters: parameters) { JSONResult, error in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                print("JSONResult - \(JSONResult)")
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForGenre parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForGenre"]))
                }
            }
        }
        return task
    }
    
    func getMoviesForSearchString(searchString: String, completionHandler: (result: [TMDBMovie]?, error: NSError?) -> Void) -> NSURLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TMDBClient.ParameterKeys.Query: searchString]
        
        /* 2. Make the request */
        let task = taskForGETMethod(Methods.SearchMovie, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.MovieResults) as? [[String : AnyObject]] {
                    
                    let movies = TMDBMovie.moviesFromResults(results)
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getMoviesForSearchString parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getMoviesForSearchString"]))
                }
            }
        }
        
        return task
    }
    
//    func getConfig(completionHandler: (didSucceed: Bool, error: NSError?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [String: AnyObject]()
//        
//        /* 2. Make the request */
//        taskForGETMethod(Methods.Config, parameters: parameters) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(didSucceed: false, error: error)
//            } else if let newConfig = TMDBConfig(dictionary: JSONResult as! [String : AnyObject]) {
//                self.config = newConfig
//                completionHandler(didSucceed: true, error: nil)
//            } else {
//                completionHandler(didSucceed: false, error: NSError(domain: "getConfig parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getConfig"]))
//            }
//        }
//    }
}