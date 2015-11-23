//
//  TMDBGenre.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import Foundation

class Genre {
    
    var genreName = ""
    var genreID = 0
    
    init(dictionary: [String : AnyObject]) {
        
        genreID = dictionary[TMDBClient.JSONResponseKeys.GenreID] as! Int
        genreName = dictionary[TMDBClient.JSONResponseKeys.GenreName] as! String
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of TMDBGenre objects */
    static func genresFromResults(results: [[String : AnyObject]]) -> [Genre] {
        var genres = [Genre]()
        
        for result in results {
            genres.append(Genre(dictionary: result))
        }
        
        return genres
    }
}