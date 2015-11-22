//
//  MovieCollectionViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 12/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieCollectionViewController: UICollectionViewController {
    
    @IBOutlet var movieCollectionView: UICollectionView!
    
    var movies = [TMDBMovie]()
    var genre: TMDBGenre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let genreName = genre?.genreName {
            navigationItem.title = genreName
        } else {
            navigationItem.title = "Now Playing"
        }
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState:.Normal)
        
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.width - (2 * space)) / space
        let heightDimension = (self.view.frame.height - (2 * space)) / space
        
        // Defining the size of CollectionView cells
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.itemSize = CGSizeMake(widthDimension, heightDimension)
        movieCollectionView.collectionViewLayout = layout
        
        if (genre != nil) {
            TMDBClient.sharedInstance().getMoviesForGenre(genre!.genreID) { results, error in
                print("via genres, error - \(error)")
                print("via genres, results - \(results)")
                self.movies = results!
                dispatch_async(dispatch_get_main_queue()) {
                    self.movieCollectionView.reloadData()
                }
            }
        } else {
            TMDBClient.sharedInstance().getNowPlayingMovies() { results, error in
                print("error - \(error)")
                //print("result - \(results!)")
            
                self.movies = results!
                print("movies - \(self.movies.count)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.movieCollectionView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        movieCollectionView.reloadData()
    }
    
    //  MARK: - CollectionView Delegates
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("inside numberOfItemsInSection count-\(movies.count)")
        return movies.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //print("inside cellForItemAtIndexPath")
        
        let movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
//            TMDBClient.sharedInstance().taskForGETImage("w154", filePath: movie.posterPath!) { imageData, error in
//                if imageData != nil {
//                    cell.movieImageView.image = UIImage(data: imageData!)
//                }
//            }
        
        if let imageData = movie.imageData {
            cell.movieImageView.image = UIImage(data: imageData)
            //cell.movieActivityIndicator.stopAnimating()
        } else {
            //cell.movieActivityIndicator.startAnimating()
            if !movie.fetchInProgress {
                movie.fetchImageData() { fetchComplete in
                    if fetchComplete {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.movieCollectionView.reloadItemsAtIndexPaths([indexPath])
                        }
                    }
                }
            }
        }
        
//        // if imageName: check in cache, else check if already downloaded, else fetch
//        if let imageData = movie.imageData {
//                let image = UIImage(data: imageData)!
//                cell.movieImageView.image = image
//                cell.movieActivityIndicator.stopAnimating()
//            } else {
//                cell.movieActivityIndicator.startAnimating()
//                if !movie.fetchInProgress {
//                    movie.fetchImageData { fetchComplete in
//                        if fetchComplete {
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.movieCollectionView.reloadItemsAtIndexPaths([indexPath])
//                            }
//                        }
//                }
//            }
//                }
//    }}

        cell.movieTitleLabel.text = movie.title
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
}