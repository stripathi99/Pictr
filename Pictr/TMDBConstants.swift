//
//  TMDBConstants.swift
//  Pictr
//
//  Created by Shubham Tripathi on 12/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

extension TMDBClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "cde3afdb3e0eefcebf0b45f56f1cc09c"
        
        // MARK: URLs
        static let BaseURL : String = "http://api.themoviedb.org/3/"
        static let BaseURLSecure : String = "https://api.themoviedb.org/3/"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
        
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Movies
        static let NowPlaying = "movie/now_playing"
        static let Popular = "movie/popular"
        static let TopRated = "movie/top_rated"
        static let Upcoming = "movie/upcoming"
        
        // MARK: Genres
        static let MovieGenres = "genre/movie/list"
        static let MoviesByGenre = "genre/{id}/movies"
        
        // MARK: Search
        static let SearchMovie = "search/movie"
        
        // MARK: Config
        static let Config = "configuration"
        
    }

//    // MARK: - URL Keys
//    struct URLKeys {
//        
//        static let UserID = "id"
//        
//    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let Query = "query"
        static let GenreID = "id"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
        
    }

    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
      
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"        
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        static let MovieOverview = "overview"
        static let MoviePopularity = "popularity"
        
        // MARK: Genres
        static let GenreID = "id"
        static let GenreName = "name"
    }
    
//    // MARK: - Poster Sizes
//    struct PosterSizes {
//        
//        static let RowPoster = TMDBClient.sharedInstance().config.posterSizes[2]
//        static let DetailPoster = TMDBClient.sharedInstance().config.posterSizes[4]
//        
//    }
}