//
//  MovieListViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 24/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var movieListSegmentControl: MovieListSegmentControl!
    @IBOutlet weak var movieListTableView: UITableView!
    
    var selectedMovie: Movie?
    
    struct ListSegmentedControlOption {
        static let WatchList = 0
        static let FavoritesList = 1
    }
    
    var currentListType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Lists"
        
        currentListType = movieListSegmentControl.selectedSegmentIndex
        
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
        movieListTableView.backgroundColor = UIColor.blackColor()
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        movieListTableView.reloadData()
    }
    
    // MARK: - TableView delegates & data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieListTableViewCell", forIndexPath: indexPath) as! MovieSegmentTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovie = fetchedResultsController.objectAtIndexPath(indexPath) as? Movie
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movieID = selectedMovie?.id
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Configure cell
    
    func configureCell(cell: MovieSegmentTableViewCell, atIndexPath indexPath: NSIndexPath) {
        let movie = fetchedResultsController.objectAtIndexPath(indexPath) as! Movie
        
        cell.movieTitleLabel.text = movie.title
        cell.moviePosterImageView.image = movie.posterImage
    }
    
    // MARK: - Core data
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        switch self.currentListType {
        case ListSegmentedControlOption.WatchList:
            fetchRequest.predicate = NSPredicate(format: "isWatched == %@", true)
        case ListSegmentedControlOption.FavoritesList:
            fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)
        default:
            break
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        movieListTableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
                        
        switch type {
        case .Insert:
            movieListTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        //case .Update:
            //self.configureCell(movieListTableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Delete:
            movieListTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.movieListTableView.endUpdates()
    }
    
    // MARK: - Segment Control
    
    @IBAction func selectList(sender: MovieListSegmentControl) {
        currentListType = movieListSegmentControl.selectedSegmentIndex
        
        switch self.currentListType {
        case ListSegmentedControlOption.WatchList:
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "isWatched == %@", true)
        case ListSegmentedControlOption.FavoritesList:
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", true)
        default:
            break
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        movieListTableView.reloadData()
    }
}
