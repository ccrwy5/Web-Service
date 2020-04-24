//
//  Model.swift
//  Web Service
//
//  Created by Chris Rehagen on 4/22/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation

struct Story {
    var abstract: String
    var byline: String
    var section: String
    var title: String
    //var link: Link
    
    init(title:String, byline: String, abstract: String, section: String) {
        self.title = title
        self.byline = byline
        self.abstract = abstract
        self.section = section
        //self.link = link
    }
}

struct Link {
    var type: String
    var urlString: String
    var linkText: String
    
    init(type: String, urlString: String, linkText: String) {
        self.type = type
        self.urlString = urlString
        self.linkText = linkText
    }
}
