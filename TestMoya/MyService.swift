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
    static let serviceUrl = URL(string: "http://api.example.com")!
}

extension MyService: TargetType {
    var baseURL: URL { return Constants.serviceUrl }

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
            return .requestParameters(parameters: ["first_name": locations[0], "last_name": locations[1]], encoding: URLEncoding.queryString)
        }
    }
    var sampleData: Data {
        switch self {
        case .zen, .search:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
