//
//  MyService.swift
//  TestMoya
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Moya

typealias MyPoint = Double

enum MyService {
    case zen
    case search(locations: [MyPoint])
}

private struct Constants {
    static let serviceUrl = URL(string: "https://api.example.com")!
}

extension MyService: TargetType {
    var baseURL: URL {
        return Constants.serviceUrl

    }

    var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .search:
            return "/locations"
        }
    }

    var method: Moya.Method {
         return .get
    }

    var task: Task {
        switch self {
        case .zen:
            return .requestPlain
        case .search(let locations):
            return .requestParameters(parameters: locations.params, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data {
        switch self {
        case .zen:
            return "Well done".utf8Encoded
        case .search(let locations):
            return locations.composeQueue(with: "test").utf8Encoded
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

