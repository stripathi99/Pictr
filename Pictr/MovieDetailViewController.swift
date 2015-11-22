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
    
    
    var movie: TMDBMovie!
    
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
        
        
        movieBackgroundImageView.image = UIImage(data: movie.imageData!)
        moviePosterImageView.image = UIImage(data: movie.imageData!)
        
        let movieReleaseYear: String = (movie.releaseDate! as NSString).substringToIndex(4)
        
        movieTitleLabel.text = "\(movie.title) (\(movieReleaseYear))"
        
        movieRatingLabel.text = "\(movie.voteAverage)/10 (\(movie.voteCount) votes)"
        
        //movieOverviewLabel.text = movie.overview
        //movieOverviewTextView.textColor = UIColor.whiteColor()
        movieOverviewTextView.text = movie.overview
    }
    
    @IBAction func addToFavorites(sender: AddToButton) {
    }
    
    @IBAction func addToWatchList(sender: AddToButton) {
    }
}
