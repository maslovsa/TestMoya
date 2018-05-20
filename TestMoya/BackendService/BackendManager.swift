//
//  BackendManager.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias Owner = OwnerDefinition
typealias Repository = RepoDefinition
typealias Repositories = [Repository]
typealias OwnerResponse = (_ owner: Owner?, _ error: Error?) -> Void
typealias RepositoriesResponse = (_ repositories: Repositories?, _ error: Error?) -> Void

class BackendManager {

    class func search(query: String, completion: RepositoriesResponse?) -> URLSessionTask? {
        guard let path = getSearchPath(query) else {
            completion?(nil, nil)
            return nil
        }
        
        let dataRequest = Alamofire.request(path).validate().responseJSON {response in
            switch response.result {
            case .success(let data):
                guard let items = (data as? [String:Any])?["items"] as? [[String:Any]] else {
                    completion?(nil, nil)
                    return
                }
                
                var repositories = Repositories()
                for item in items {
                    let repository = Mapper<RepoDefinition>().map(JSON:item)
                    repositories.append(repository!)
                }
                completion?(repositories, nil)
                
            case .failure(let error):
                completion?(nil, error)
            }
        }
        
        return dataRequest.task
    }
    
    class func getUserDetails(username: String, completion: OwnerResponse?) {
        guard let path = getUserSearchPath(username) else {
            completion?(nil, nil)
            return
        }
        
        Alamofire.request(path).validate().responseJSON {response in
            switch response.result {
            case .success(let data):
                guard let item = data as? [String:Any] else {
                    completion?(nil, nil)
                    return
                }
                
                let owner = Mapper<OwnerDefinition>().map(JSON:item)
                completion?(owner, nil)
                
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    
    private class func getSearchPath(_ query: String) -> String? {
        if !query.isEmpty {
            return String.init(format: "https://api.github.com/search/repositories?q=%@", query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        } else {
            return nil
        }
    }
    
    private class func getUserSearchPath(_ userName: String) -> String? {
        if !userName.isEmpty {
            return String.init(format: "https://api.github.com/users/%@", userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        } else {
            return nil
        }
    }
}
