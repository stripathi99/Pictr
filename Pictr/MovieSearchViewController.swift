//
//  MovieSearchViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit
import CoreData

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
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieSearchResultCell") as UITableViewCell!
        
        //let movieReleaseYear: String = (movie.releaseDate! as NSString).substringToIndex(4)
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movie = searchResults[indexPath.row]
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movieID = movie.id
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // Method to get search resuts
    private func searchMovies(searchString: String) {
        
        if let task = searchTask {
            task.cancel()
        }
        
        searchTask = TMDBClient.sharedInstance().getMoviesForSearchString(searchString) { results, error in
            self.searchTask = nil
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                if let moviesDictionary = results {
                    let movies = moviesDictionary.map() { (dictionary: [String : AnyObject]) -> Movie in
                        let movie = Movie(dictionary: dictionary, context: self.sharedContext)
                        return movie
                    }
                    self.searchResults = movies
                    dispatch_async(dispatch_get_main_queue()) {
                        self.movieSearchActivityIndicator.stopAnimating()
                        self.movieSearchTableView.reloadData()
                    }
                }
            }
        }
    }
}