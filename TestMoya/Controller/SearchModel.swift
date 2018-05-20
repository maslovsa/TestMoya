//
//  SearchModel.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper


protocol SearchModelInput: class {
    var output: SearchModelOutput? { get set }
    var repositories: Repositories { get }
    var hasUserSearchResults: Bool { get }
    func search(_ query: String)
    func getLastSearch() -> String?
    func viewWillAppear()
}

protocol SearchModelOutput: class {
    func resultsUpdated(isSuccess: Bool)
    func didStartSearch()
    func didFinishSearch()
}

class SearchModel: SearchModelInput {
    
    var repositories = Repositories()
    weak var output: SearchModelOutput?
    
    var hasUserSearchResults: Bool {
        return repositories.count > 0
    }
    
    private var task: URLSessionTask?
    private var token: Cancellable?

    let provider = MoyaProvider<GitService>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: Constants.JSONResponseDataFormatter)])
    
    func viewWillAppear() {
        StorageManager.shared.updateRepositorySignal.subscribePast(with: self) { [weak self](repo) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.updateFeaturedRepos() {
                strongSelf.output?.resultsUpdated(isSuccess: false)
            }
            }.onQueue(DispatchQueue.main)
    }
    
    func search(_ query: String) {
//        task?.cancel()
        token?.cancel()

        output?.didStartSearch()
        
        if query.isEmpty {
            repositories = Repositories()
            output?.resultsUpdated(isSuccess: false)
            output?.didFinishSearch()
            return
        }
        StorageManager.shared.updateLastSearch(query)

        let request = GitService.search(query: query)

//        GitHubProvider.request(.userRepositories(username))
//            .mapArray(Repository.self)
//            .subscribe { event -> Void in
//                switch event {
//                case .next(let repos):
//                    self.repos = repos
//                case .error(let error):
//                    print(error)
//                default: break
//                }
//            }.addDisposableTo(disposeBag)
        
        token = provider.request(request, completion: {
            [weak self] result in

            self?.output?.didFinishSearch()
            
            guard let sself = self else {
                return
            }

            switch result {
            case .success(let response):
                var success = true
                var repositories = Repositories()

                do {
                    let repos: [Repository]? = try response.mapArray(Repository.self)
                    if let repos = repos {
                        // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                        repositories = repos
                    } else {
                        success = false
                    }
                } catch {
                    success = false
                }


                sself.repositories = repositories
                let _ = sself.updateFeaturedRepos()
                sself.output?.resultsUpdated(isSuccess: success)

            case .failure(let error):
                print(error)
            }
        })

    }
    
    func getLastSearch() -> String? {
        return StorageManager.shared.storage.lastSearch
    }
    
    private func updateFeaturedRepos() -> Bool {
        var hasUpdates = false
        repositories = repositories.map { repo in
            if StorageManager.shared.isRepoFeatured(repo) {
                repo.isFeatured = true
                hasUpdates = true
            }
            return repo
        }
        
        return hasUpdates
    }
    
}
