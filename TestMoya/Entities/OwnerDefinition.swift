//
//  OwnerDefinition.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import ObjectMapper

class OwnerDefinition: BaseDefinition {
    var login: String?
    var avatarURL: String?
    var url: String?
    var email: String?
    var name: String?
    var location: String?
    
    var fullName: String {
        let login = self.login ?? "no login"
        let name = self.name ?? ""
        return "\(login) \(name)"
    }
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        login <- map["login"]
        avatarURL <- map["avatar_url"]
        url <- map["url"]
        email <- map["email"]
        name <- map["name"]
        location <- map["location"]
    }
    
    override var description: String {
        let superDescription = super.description
        let login = self.login ?? "no login"
        let email = self.email ?? "no email"
        return "\(superDescription) login:\(login) email:\(email)"
    }
}
