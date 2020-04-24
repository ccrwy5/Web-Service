//
//  StoriesTableViewController.swift
//  Web Service
//
//  Created by Chris Rehagen on 4/22/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class StoriesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var storiesTableView: UITableView!
    
    var storiesCollection: [Story]?
    var searchController: UISearchController!
    let initialSearchText = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Stories"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        storiesTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.text = initialSearchText


    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            NewYorkTimesTopStories.search(searchText: searchText, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
                (userInfo, movieReviews, errorString) in
                if errorString != nil {
                    // could put a call to an alert here to notify user of issue
                    self.storiesCollection = nil
                } else {
                    self.storiesCollection = movieReviews
                }
                self.storiesTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storiesCollection?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if let cell = cell as? StoryTableViewCell, let storyForCell = storiesCollection?[indexPath.row] {

            cell.titleLabel.text = storyForCell.title
            cell.bylineLabel.text = storyForCell.byline
            cell.abstractLabel.text = storyForCell.section
            
        }
        print("cell set")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.performSegue(withIdentifier: "showDetails", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StoryDetailsViewController,
           let indexPath = storiesTableView.indexPathForSelectedRow,
           let numReviews = storiesCollection?.count,
           indexPath.row < numReviews,
           let story = storiesCollection?[indexPath.row] {
                destination.individualStory = story
        }
        searchController.dismiss(animated: true, completion: {})
    }


}


