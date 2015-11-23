//
//  MovieDetailViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 17/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var movieBackgroundImageView: UIImageView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: AddToButton!
    @IBOutlet weak var addToWatchListButton: AddToButton!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    
    var movie: Movie!
    
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
    
        setMovieImage()
        setMovieTitle()
        setMovieRating()
        setMovieOverview()
    }
    
    func setMovieTitle() {
        let movieReleaseYear: String = (movie.releaseDate! as NSString).substringToIndex(4)
        movieTitleLabel.text = "\(movie.title) (\(movieReleaseYear))"
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
                        self.movie.posterImage = UIImage(data: data)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.movieBackgroundImageView.image = self.movie.posterImage
                            self.moviePosterImageView.image = self.movie.posterImage
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func setMovieRating() {
        movieRatingLabel.text = "\(movie.voteAverage)/10 (\(movie.voteCount) votes)"
    }
    
    func setMovieOverview() {
        movieOverviewTextView.text = movie.overview
    }
    
    @IBAction func addToFavorites(sender: AddToButton) {
    }
    
    @IBAction func addToWatchList(sender: AddToButton) {
    }
}
