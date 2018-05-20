//
//  SearchModel.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation

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
        task?.cancel()
        output?.didStartSearch()
        
        if query.isEmpty {
            repositories = Repositories()
            output?.resultsUpdated(isSuccess: false)
            output?.didFinishSearch()
            return
        }
        StorageManager.shared.updateLastSearch(query)
        
        task = BackendManager.search(query: query) { [weak self]
            (repositories, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let repositories = repositories, error == nil {
                strongSelf.repositories = repositories
                let _ = strongSelf.updateFeaturedRepos()
                strongSelf.output?.resultsUpdated(isSuccess: true)
                print("For \(query) found \(repositories.count) repositories")
            } else {
                strongSelf.output?.resultsUpdated(isSuccess: false)
                print("For \(query) found nothing")
            }
            strongSelf.output?.didFinishSearch()
        }
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
