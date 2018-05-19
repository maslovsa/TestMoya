//
//  QueueHelper.swift
//  TestMoya
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation




extension Array where Element: CustomStringConvertible {

    public var params: [String: Any] {
        return [:]
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
