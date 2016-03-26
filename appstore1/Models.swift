//
//  Models.swift
//  appstore1
//
//  Created by Brian Voong on 3/21/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            
            for dict in value as! [[String: AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeysWithDictionary(dict)
                appCategories?.append(appCategory)
            }
            
        } else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeysWithDictionary(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
}

class AppCategory: NSObject {
    
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "apps" {
            
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeysWithDictionary(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: (FeaturedApps) -> ()) {
        
        let urlString = "http://www.statsallday.com/appstore/featured"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!) { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                
                let json = try(NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers))
                
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeysWithDictionary(json as! [String: AnyObject])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(featuredApps)
                })
                
            } catch let err {
                print(err)
            }
            
        }.resume()
        
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        // logic
        let frozenApp = App()
        frozenApp.name = "Disney Build It: Frozen"
        frozenApp.imageName = "frozen"
        frozenApp.category = "Entertainment"
        frozenApp.price = NSNumber(float: 3.99)
        apps.append(frozenApp)
        
        bestNewAppsCategory.apps = apps
        
        
        let bestNewGamesCategory = AppCategory()
        bestNewGamesCategory.name = "Best New Games"
        
        var bestNewGamesApps = [App]()
        
        let telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.category = "Games"
        telepaintApp.imageName = "telepaint"
        telepaintApp.price = NSNumber(float: 2.99)
        
        bestNewGamesApps.append(telepaintApp)
        
        bestNewGamesCategory.apps = bestNewGamesApps
        
        return [bestNewAppsCategory, bestNewGamesCategory]
        
    }
    
}

class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
}
