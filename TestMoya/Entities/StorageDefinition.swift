//
//  StorageDefinition.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import ObjectMapper

class StorageDefinition: BaseDefinition {
    var lastSearch: String?
    var featuredRepos = [RepoDefinition]()
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        lastSearch <- map["lastSearch"]
        featuredRepos <- map["featuredRepos"]
    }
    
    override var description: String {
        let lastSearch = self.lastSearch ?? "no lastSearch"
        let featuredReposCount = self.featuredRepos.count
        return "lastSearch - \(lastSearch) featuredReposCount: \(featuredReposCount)"
    }
    
    class func defaultInstance() -> StorageDefinition{
        let dic = ["id": 0] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let theJSONText = String(data: jsonData, encoding: .utf8)!
        return Mapper<StorageDefinition>().map(JSONString: theJSONText)!
    }
}

