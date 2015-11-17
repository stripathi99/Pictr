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
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
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
        
        movieTitleLabel.text = "\n \(movie.title)"
        
        //movieOverviewLabel.text = movie.overview
        //movieOverviewTextView.textColor = UIColor.whiteColor()
        movieOverviewTextView.text = movie.overview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
