//
//  GitService.swift
//  TestMoya
//
//  Created by Sergey Maslov on 20.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Moya

typealias Owner = OwnerDefinition
typealias Repository = RepoDefinition
typealias Repositories = [Repository]

enum GitService {
    case search(query: String)
    case getUserDetails(userName: String)
}

extension GitService: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .search:
            return "/search/repositories"
        case .getUserDetails(let userName):
            return String.init(format: "/users/%@", userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .search(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
        case .getUserDetails:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .search:
            return "Well done".utf8Encoded
        case .getUserDetails:
            return "Well done".utf8Encoded
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
