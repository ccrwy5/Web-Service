//
//  ViewController.swift
//  Web Service
//
//  Created by Chris Rehagen on 4/22/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var storiesCollection: [Story]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSearchResults()
        //print("started")
//        if let story = storiesCollection {
//            print(story)
//            
//        }
    }
    
    func updateSearchResults() {
        let testing: String? = "player"
        if let searchText = testing {

            NewYorkTimesTopStories.search(searchText: searchText, userInfo: nil, dispatchQueueForHandler: DispatchQueue.main) {
                (userInfo, movieReviews, errorString) in
                if errorString != nil {
                    // could put a call to an alert here to notify user of issue
                    print("error")
                    self.storiesCollection = nil
                } else {
                    print("success")
                    self.storiesCollection = movieReviews
                    //print(self.storiesCollection)

                }
                //self.tableView.reloadData()
            }
        }
    }


}

