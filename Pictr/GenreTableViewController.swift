//
//  GenreTableViewController.swift
//  Pictr
//
//  Created by Shubham Tripathi on 22/11/15.
//  Copyright © 2015 coolshubh4. All rights reserved.
//

import UIKit
import CoreData

class GenreTableViewController: UITableViewController {

    @IBOutlet var genreTableView: UITableView!
    private var genres = [Genre]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Genres"
        
        let fetchRequest = NSFetchRequest(entityName: "Genre")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            genres = try sharedContext.executeFetchRequest(fetchRequest) as! [Genre]
            if genres.count == 0 {
                getAllGenres()
            }
        } catch {
            fatalError("error - \(error)")
        }
        
        genreTableView.delegate = self
        genreTableView.dataSource = self
    }

    private func getAllGenres() {
        TMDBClient.sharedInstance().getGenres() { results , error in
            if (error != nil) {
                print("\(error?.localizedDescription)")
            } else {
                if let genresDictionary = results {
                    let genres = genresDictionary.map() { (dictionary: [String : AnyObject]) -> Genre in
                        let genre = Genre(dictionary: dictionary, context: self.sharedContext)
                        return genre
                    }
                    self.genres = genres
                    dispatch_async(dispatch_get_main_queue()) {
                        self.genreTableView.reloadData()
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            do {
                try self.sharedContext.save()
            } catch {
                fatalError("error while saving, error - \(error)")
            }
        }
    }
    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let genre = genres[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("genre") as UITableViewCell!
        
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = genre.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MovieCollectionViewController") as! MovieCollectionViewController
        
        controller.genre = genres[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
