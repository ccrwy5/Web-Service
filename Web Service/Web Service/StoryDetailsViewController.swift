//
//  StoryDetailsViewController.swift
//  Web Service
//
//  Created by Chris Rehagen on 4/22/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

class StoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    var individualStory: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Review"

        if let individualStory = individualStory {
            titleLabel.text = individualStory.title
            abstractLabel.text = "Synopsis:\n\(individualStory.abstract)"
            authorLabel.text = individualStory.byline
        }
    }
}
