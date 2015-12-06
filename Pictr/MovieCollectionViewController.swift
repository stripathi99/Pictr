//
//  MovieCollectionViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 12/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit
import CoreData

class MovieCollectionViewController: UICollectionViewController {
    
    @IBOutlet var movieCollectionView: UICollectionView!
    @IBOutlet weak var fetchMoviesActivityIndicator: UIActivityIndicatorView!
    
    private var movies = [Movie]()
    var genre: Genre?
    var moviesToDisplay = "Now Playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMoviesActivityIndicator.hidesWhenStopped = true
        fetchMoviesActivityIndicator.stopAnimating()
        
        
        if let genreName = genre?.name {
            navigationItem.title = genreName
        } else {
            
            // Sidebar menu
            if revealViewController() != nil {
                navigationItem.title = moviesToDisplay
                let sidebarMenuButton = UIBarButtonItem(image: UIImage(named: "sidebarMenu"), style: .Plain, target: revealViewController(), action: "revealToggle:")
                navigationItem.leftBarButtonItem = sidebarMenuButton
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        // Defining the size of CollectionView cells
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.width - (2 * space)) / space
        let heightDimension = (self.view.frame.height - (2 * space)) / space
        
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.itemSize = CGSizeMake(widthDimension, heightDimension)
        movieCollectionView.collectionViewLayout = layout
        
        if (genre != nil) {
            getAllMoviesForGenres()
        } else {
            getAllMovies()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Getting Movies
    
    private func getAllMovies() {
        
        fetchMoviesActivityIndicator.startAnimating()
        TMDBClient.sharedInstance().getMovies(moviesToDisplay) { results, error in
            if error != nil {
                self.displayAlertView(error?.localizedDescription, methodToCallForRetry: "movieRetry")
            } else {
                if let moviesDictionary = results {
                    let movies = moviesDictionary.map() { (dictionary: [String : AnyObject]) -> Movie in
                        let movie = Movie(dictionary: dictionary, context: self.sharedContext)
                        return movie
                    }
                    self.movies = movies
                    dispatch_async(dispatch_get_main_queue()) {
                        self.movieCollectionView.reloadData()
                        self.fetchMoviesActivityIndicator.stopAnimating()
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.sharedContext.save()
            } catch {
                fatalError("error saving the movies, error - \(error)")
            }
        }
    }
    
    private func getAllMoviesForGenres() {
        
        fetchMoviesActivityIndicator.startAnimating()
        TMDBClient.sharedInstance().getMoviesForGenre(Int(genre!.id.intValue)) { results, error in
            if error != nil {
                self.displayAlertView(error?.localizedDescription, methodToCallForRetry: "genreRetry")
            } else {
                if let moviesDictionary = results {
                    let movies = moviesDictionary.map() { (dictionary: [String : AnyObject]) -> Movie in
                        let movie = Movie(dictionary: dictionary, context: self.sharedContext)
                        return movie
                    }
                    self.movies = movies
                    dispatch_async(dispatch_get_main_queue()) {
                        self.movieCollectionView.reloadData()
                        self.fetchMoviesActivityIndicator.stopAnimating()
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.sharedContext.save()
            } catch {
                fatalError("error saving the movies, error - \(error)")
            }
        }
    }
    
    private func displayAlertView(alertMessage: String!, methodToCallForRetry: String!) {
        
        let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            
            if methodToCallForRetry == "movieRetry" {
                self.getAllMovies()
            } else {
                self.getAllMoviesForGenres()
            }
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }
    
    //  MARK: - CollectionView Delegates
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var posterImage = UIImage(named: "posterPlaceholder")
        
        let movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        if movie.posterPath == nil || movie.posterPath == "" {
            posterImage = UIImage(named: "noImage")
        }
        else if (movie.posterImage != nil) {
            posterImage = movie.posterImage
        }
        else {
        
            let task = TMDBClient.sharedInstance().taskForGETImage("w185", filePath: movie.posterPath!) {
                data, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        movie.posterImage = image
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.movieImageView.image = image
                        }
                    }
                }
            }
            cell.taskToCancelifCellIsReused = task
        }
    
        cell.movieImageView.image = posterImage
        cell.movieTitleLabel.text = movie.title
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let movie = movies[indexPath.row]
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movieID = movie.id
        //controller.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
}