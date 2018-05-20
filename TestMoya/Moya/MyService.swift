//
//  MyService.swift
//  TestMoya
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Moya

// MARK: - Task: 1
public typealias MyPoint = Double

enum MyService {
    case zen
    case search(locations: [MyPoint])
}

extension MyService: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.example.com")!
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
            return MoyaTaskHelper.task(from: locations)
        }
    }

    var sampleData: Data {
        switch self {
        case .zen:
            return "Well done".utf8Encoded
        case .search(let locations):
            return locations.composeQuery(with: "test").utf8Encoded
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
