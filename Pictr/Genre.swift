//
//  TMDBGenre.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import Foundation
import CoreData

class Genre {
    
    var genreName: String
    var genreID: Int
    
    init(dictionary: [String : AnyObject]) {
        
        genreID = dictionary[TMDBClient.JSONResponseKeys.GenreID] as! Int
        genreName = dictionary[TMDBClient.JSONResponseKeys.GenreName] as! String
    }
}