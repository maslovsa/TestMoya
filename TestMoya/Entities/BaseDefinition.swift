//
//  BaseDefinition.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseDefinition: NSObject, Mappable, NSCoding {
    var id: Int!
    
    override init() {
    }
    
    required public init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
    
    public func encode(with aCoder: NSCoder) {
        guard let JSONString = Mapper().toJSONString(self, prettyPrint: true),
            let data = JSONString.data(using: .utf8) else {
                return
        }
        
        aCoder.encode(data)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let data = aDecoder.decodeData(),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                self.init()
                return
        }
        let map = Map(mappingType: .fromJSON, JSON: dictionary!, toObject: false, context: nil, shouldIncludeNilValues: true)
        self.init()
        self.mapping(map: map)
        
    }
    
    override var description: String {
        return "id = \(id!)"
    }
}

//extension BaseDefinition: CustomStringConvertible {
//
//}
