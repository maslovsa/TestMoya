//
//  MoyaHelper.swift
//  TestMoya
//
//  Created by Sergey Maslov on 20.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Alamofire
import Moya

public extension URLEncoding {
    public static var queryCustomString: Alamofire.URLEncoding {
        return Alamofire.URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
    }
}

public struct MoyaTaskHelper {
    static func task(from array: [MyPoint]) -> Task {
        return .requestParameters(parameters: array.params, encoding: URLEncoding.queryCustomString)
    }
}
