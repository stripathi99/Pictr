//
//  TMDBGenre.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import Foundation

class TMDBGenre {
    
    var genreName = ""
    var genreID = 0
    
    init(dictionary: [String : AnyObject]) {
        
        genreID = dictionary[TMDBClient.JSONResponseKeys.GenreID] as! Int
        genreName = dictionary[TMDBClient.JSONResponseKeys.GenreName] as! String
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBGenre objects */
    static func genresFromResults(results: [[String : AnyObject]]) -> [TMDBGenre] {
        var genres = [TMDBGenre]()
        
        for result in results {
            genres.append(TMDBGenre(dictionary: result))
        }
        
        return genres
    }
}