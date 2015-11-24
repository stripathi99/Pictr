//
//  MovieDetailViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 17/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: AddToButton!
    @IBOutlet weak var addToWatchListButton: AddToButton!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    var movieID: NSNumber!
    private var movie: Movie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let blurredEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurredEffectView = UIVisualEffectView(effect: blurredEffect)
        blurredEffectView.frame = movieBackgroundImageView.bounds
        blurredEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        movieBackgroundImageView.addSubview(blurredEffectView)
        
        movieBackgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        moviePosterImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        movie = fetchMovie()
       
        setMovieImage()
        setMovieTitle()
        setMovieRating()
        setMovieOverview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setTitleForWatchListButton()
        setTitleForFavoritesButton()
    }
    
    func fetchMovie() -> Movie {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: sharedContext)
        fetchRequest.predicate = NSPredicate(format: "id=%@", movieID)
        
        do {
            let fetchedMovie = try sharedContext.executeFetchRequest(fetchRequest)
            return fetchedMovie.first as! Movie
        } catch {
            return Movie()
        }
    }
    
    func setMovieTitle() {
        
        if let releaseDate = movie.releaseDate {
            let movieReleaseYear: String = (releaseDate as NSString).substringToIndex(4)
            movieTitleLabel.text = "\(movie.title) (\(movieReleaseYear))"
        } else {
            movieTitleLabel.text = movie.title
        }
    }
    
    func setMovieImage() {
        
        if movie.posterImage != nil {
            movieBackgroundImageView.image = movie.posterImage
            moviePosterImageView.image = movie.posterImage
        } else {
            let task = TMDBClient.sharedInstance().taskForGETImage("w185", filePath: movie.posterPath!) { data, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        self.movie.posterImage = image
                        dispatch_async(dispatch_get_main_queue()) {
                            self.movieBackgroundImageView.image = image
                            self.moviePosterImageView.image = image
                        }
                    }
                }
            }
        task.resume()
    }
    }
    
    func setMovieRating() {
        movieRatingLabel.text = "\(movie.voteAverage!)/10 (\(movie.voteCount!) votes)"
    }
    
    func setMovieOverview() {
        movieOverviewTextView.text = movie.overview
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }
    
    @IBAction func addToFavorites(sender: AddToButton) {
        movie.isFavorite = !movie.isFavorite
        CoreDataStackManager.sharedInstance.saveContext()
        setTitleForFavoritesButton()
    }
    
    @IBAction func addToWatchList(sender: AddToButton) {
        movie.isWatched = !movie.isWatched
        CoreDataStackManager.sharedInstance.saveContext()
        setTitleForWatchListButton()
    }
    
    private func setTitleForWatchListButton() {
        if movie.isWatched {
            addToWatchListButton.setTitle("Remove from Watch List", forState: UIControlState.Normal)
        } else {
            addToWatchListButton.setTitle("Add to Watch List", forState: UIControlState.Normal)
        }
    }
    
    private func setTitleForFavoritesButton() {
        if movie.isFavorite {
            addToFavoritesButton.setTitle("Remove from Favorites", forState: UIControlState.Normal)
        } else {
            addToFavoritesButton.setTitle("Add to Favorites", forState: UIControlState.Normal)
        }
    }
}
