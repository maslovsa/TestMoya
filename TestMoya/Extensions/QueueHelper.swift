//
//  QueueHelper.swift
//  TestMoya
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Alamofire

extension Array where Element: CustomStringConvertible {

    public var params: Alamofire.Parameters {
        return Dictionary(grouping: self, by: { $0.description } )
    }

    public func composeQueue(with key: String) -> String {
        var result = ""
        result = self.reduce(result, { $0 + "&" + "\(key)=\($1.description)" })
        if let index = result.index(of: "&") {
        result.remove(at: index)
    }
    return result
}

}
