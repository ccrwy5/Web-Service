//
//  NewYorkTimesTopStories.swift
//  Web Service
//
//  Created by Chris Rehagen on 4/22/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import Foundation



class NewYorkTimesTopStories {
    
    static let baseUrlString = "https://api.nytimes.com/svc/topstories/v2/sports.json?api-key="
    static let apiKey = "4MbBBU7LRFkKozjDntqKt3bZCaix22Tt"
    static let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)

    
    
    class func search(searchText: String, userInfo: Any?, dispatchQueueForHandler: DispatchQueue, completionHandler: @escaping (Any?, [Story]?, String?) -> Void) {
        print("Key: \(baseUrlString)\(apiKey)")

        print("search called")
        
        guard let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "problem preparing search text")
            })
            return
        }
        let urlString = baseUrlString + apiKey
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        guard let url = URL(string: urlString) else {
            dispatchQueueForHandler.async(execute: {
                completionHandler(userInfo, nil, "the url for searching is invalid")
            })
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil, let data = data else {
                var errorString = "data not available from search"
                if let error = error {
                    errorString = error.localizedDescription
                }
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
                return
            }
            
            let (stories, errorString) = parse(with: data)
            if let errorString = errorString {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, nil, errorString)
                })
            } else {
                dispatchQueueForHandler.async(execute: {
                    completionHandler(userInfo, stories, nil)
                })
            }
        }
        
        task.resume()
    }
    
    
    
    
    
    class func parse(with data: Data) -> ([Story]?, String?) {
        
        // for debugging: to see json as String printed
        if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            //print(jsonString)
        }
       
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let rootNode = json as? [String:Any] else {
            return (nil, "unable to parse response from news server")
        }
        
        guard let status = rootNode["status"] as? String, status == "OK" else {
            return (nil, "server did not return OK")
        }
        
        
        var storiesCollection = [Story]()
        
        if let results = rootNode["results"] as? [[String: Any]] {
            for result in results {
                if let abstract = result["abstract"] as? String,
                    let byline = result["byline"] as? String,
                    let subsection = result["subsection"] as? String,
                    let title = result["title"] as? String
//                    let linkNode = result["link"] as? [String:String],
//                    let linkType = linkNode["type"],
//                    let linkUrlString = linkNode["url"],
//                    let linkText = linkNode["suggested_link_text"]
                {
                    
//                   let link = Link(type: linkType, urlString: linkUrlString, linkText: linkText)
                    let story = Story(title: title, byline: byline, abstract: abstract, section: subsection)
                        storiesCollection.append(story)
                    //print(story)
                }
            }
        }

        return (storiesCollection, nil)

    }

}
