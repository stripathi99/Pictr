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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.title = "Now Playing"
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        movieCollectionView.reloadData()
    }
    
    // MARK: - Layout
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        let layout = UICollectionViewFlowLayout()
//        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumLineSpacing = minimumSpacingPerCell
//        layout.minimumInteritemSpacing = minimumSpacingPerCell
//        
//        var cellWidth: CGFloat!
//        
////        // Landscape
////        if UIApplication.sharedApplication().statusBarOrientation.isLandscape == true {
////            let totalSpacingBetweenCells = (minimumSpacingPerCell * cellsPerRowInLandscpaeMode) - minimumSpacingPerCell
////            let availableWidthForCells = collectionView.frame.size.width - totalSpacingBetweenCells
////            cellWidth = availableWidthForCells / cellsPerRowInLandscpaeMode
////            
////            // Portrait
////        } else {
////            let totalSpacingBetweenCells = (minimumSpacingPerCell * cellsPerRowInPortraitMode) - minimumSpacingPerCell
////            let availableWidthForCells = collectionView.frame.size.width - totalSpacingBetweenCells
////            cellWidth = availableWidthForCells / cellsPerRowInPortraitMode
////        }
//        
//        let totalSpacingBetweenCells = (minimumSpacingPerCell * cellsPerRow) - minimumSpacingPerCell
//        let availableWidthForCells = movieCollectionView.frame.size.width - totalSpacingBetweenCells
//        cellWidth = availableWidthForCells / cellsPerRow
//        
//        // Get 2 digit floored decimal point precision
//        cellWidth = floor(cellWidth*100)/100
//        
//        // In storyboard, the manga image height:width ratio is specified as 1.3:1,
//        // 44 points is fixed space allocated to title and author labels
//        //layout.itemSize = CGSize(width: cellWidth, height: (cellWidth*1.3) + 44)
//        movieCollectionView.collectionViewLayout = layout
//    }
    
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