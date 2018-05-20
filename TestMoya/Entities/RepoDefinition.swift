//
//  RepoDefinition.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import ObjectMapper

class RepoDefinition: BaseDefinition {
    var name: String?
    var fullName: String?
    var repoDescription: String?
    var owner: OwnerDefinition?
    var isFeatured: Bool = false
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        fullName <- map["full_name"]
        repoDescription <- map["description"]
        owner <- map["owner"]
        isFeatured <- map["isFeatured"]
    }
    
    override var description: String {
        let superDescription = super.description
        let featured = isFeatured ? "★" : "☆"
        let name = self.name ?? "no name"
        let fullName = self.fullName ?? "no fullName"
        let owner = self.owner?.description ?? "no owner"
        return "\(featured) \(superDescription) name:\(name) fullName:\(fullName) owner:\(owner)"
    }
}
