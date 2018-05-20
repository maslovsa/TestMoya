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
import RxMoya
import RxSwift

typealias dictionaryJSON = [String: Any]

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
    let disposeBag = DisposeBag()

    let provider = MoyaProvider<GitService>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: Constants.JSONResponseDataFormatter)])
    
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
        token?.cancel()
        output?.didStartSearch()
        
        if query.isEmpty {
            repositories = Repositories()
            output?.resultsUpdated(isSuccess: false)
            output?.didFinishSearch()
            return
        }
        StorageManager.shared.updateLastSearch(query)

        provider.rx.request(GitService.search(query: query))
            .debug()
            .prepareArray(for: "items")
            .mapArray(Repository.self)
            .subscribe {
                [weak self] event -> Void in

                var success = true
                var repositories = Repositories()

                self?.output?.didFinishSearch()
                guard let sself = self else {
                    return
                }

                switch event {
                case .success(let repos):
                    repositories = repos
                    success = true

                case .error(let error):
                    print(error)
                    success = false
                }

                sself.repositories = repositories
                let _ = sself.updateFeaturedRepos()
                sself.output?.resultsUpdated(isSuccess: success)
            }
        .disposed(by: disposeBag)
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
