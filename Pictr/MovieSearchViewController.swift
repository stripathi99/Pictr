//
//  MovieSearchViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var movieSearchTableView: UITableView!
    @IBOutlet weak var movieSearchActivityIndicator: UIActivityIndicatorView!
    
    var movieSearchController: UISearchController!
    var singleTapInSearchModeGestureRecognizer: UITapGestureRecognizer!
    var searchTask: NSURLSessionDataTask?
    private var fetchInProgressCount = 0
    
    private var searchResults = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        movieSearchTableView.delegate = self
        movieSearchTableView.dataSource = self
        movieSearchTableView.backgroundColor = UIColor.blackColor()
        
        movieSearchActivityIndicator.hidesWhenStopped = true
        movieSearchActivityIndicator.stopAnimating()
        
        singleTapInSearchModeGestureRecognizer = UITapGestureRecognizer(target: self, action: "singleTapInSearchMode:")
        singleTapInSearchModeGestureRecognizer.numberOfTapsRequired = 1
        
        // Search Controller
        movieSearchController = UISearchController(searchResultsController: nil)
        movieSearchController.searchResultsUpdater = self
        movieSearchController.dimsBackgroundDuringPresentation = false
        movieSearchController.searchBar.delegate = self
        movieSearchController.searchBar.sizeToFit()
        movieSearchController.searchBar.placeholder = "Search Movies (by title)"
        
        movieSearchTableView.tableHeaderView = movieSearchController.searchBar
        self.definesPresentationContext = true
        
//        movieSearchTableView.estimatedRowHeight = 62.0
//        movieSearchTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - UIGesture
    func singleTapInSearchMode(recognizer: UITapGestureRecognizer) {
        movieSearchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchController delegates
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        
        if !searchString.isEmpty || searchResults.count > 0 {
            movieSearchActivityIndicator.startAnimating()
            searchMovies(searchString)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        view.addGestureRecognizer(singleTapInSearchModeGestureRecognizer)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        view.removeGestureRecognizer(singleTapInSearchModeGestureRecognizer)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchResults = [Movie]()
        dispatch_async(dispatch_get_main_queue()) {
            self.movieSearchActivityIndicator.stopAnimating()
            self.movieSearchTableView.reloadData()
        }
    }
    
    // MARK: - TableView delegates & datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let movie = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieSearchResultCell") as! MovieTableViewCell
        
        let movieReleaseYear: String = (movie.releaseDate! as NSString).substringToIndex(4)
        cell.movieTitleLabel.text = "\(movie.title) (\(movieReleaseYear))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = searchResults[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // Method to get search resuts
    func searchMovies(searchString: String) {
        
        if let task = searchTask {
            task.cancel()
        }
        
        searchTask = TMDBClient.sharedInstance().getMoviesForSearchString(searchString) { results, error in
            self.searchTask = nil
            if let movieResults = results {
                self.searchResults = movieResults
                dispatch_async(dispatch_get_main_queue()) {
                    self.movieSearchActivityIndicator.stopAnimating()
                    self.movieSearchTableView.reloadData()
                }
            }
        }
    }
}