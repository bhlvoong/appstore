//
//  Models.swift
//  appstore1
//
//  Created by Brian Voong on 3/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

struct FeaturedApps: Decodable {
    
    var bannerCategory: AppCategory?
    var categories: [AppCategory]?
    
}

struct AppCategory: Decodable {
    
    let name: String?
    let apps: [App]?
    let type: String?
    
    static func fetchFeaturedApps(_ completionHandler: @escaping (FeaturedApps) -> ()) {
        
        let urlString = "http://www.statsallday.com/appstore/featured"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let featuredApps = try decoder.decode(FeaturedApps.self, from: data)
                print(featuredApps)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(featuredApps)
                })
                
            } catch let err {
                print(err)
            }
            
        }) .resume()
        
    }
}

struct App: Decodable {
    
    let Id: Int?
    var Name: String?
    var Category: String?
    var ImageName: String?
    var Price: Float?
    
    var Screenshots: [String]?
    var description: String?
    var appInformation: [AppInformation]?
}

struct AppInformation: Decodable {
    let Name: String
    let Value: String
}
