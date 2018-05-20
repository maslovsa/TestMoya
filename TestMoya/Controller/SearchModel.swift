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
    func didUpdatedResults()
    func didStartSearch()
    func didFinishSearch()
}

class SearchModel: SearchModelInput {

    weak var output: SearchModelOutput?
    var repositories = Repositories() {
        didSet {
            updateFeaturedRepos()
            output?.didUpdatedResults()
        }
    }

    var hasUserSearchResults: Bool {
        return repositories.count > 0
    }
    
    private let disposeBag = DisposeBag()

    let provider = MoyaProvider<GitService>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: Constants.JSONResponseDataFormatter)])
    
    func viewWillAppear() {
        StorageManager.shared.updateRepositorySignal.subscribePast(with: self) {
            [weak self] repo in
            if let strongSelf = self, strongSelf.updateFeaturedRepos() {
                strongSelf.output?.didUpdatedResults()
            }
            }.onQueue(DispatchQueue.main)
    }
    
    func search(_ query: String) {

        output?.didStartSearch()
        
        if query.isEmpty {
            repositories = Repositories()
            output?.didFinishSearch()
            return
        }
        StorageManager.shared.updateLastSearch(query)

        provider.rx.requestWithProgress(GitService.search(query: query))
            .trackActivity(with: {
                [weak self] completed in
                if completed {
                    self?.output?.didFinishSearch()
                }
            })
            .debug()
            .prepareResponse(for: "items")
            .mapArray(Repository.self)
            .subscribe {
                [weak self] event -> Void in

                switch event {
                case .next(let repositories):
                    self?.repositories = repositories

                case .error(let error):
                    print(error)

                case .completed:
                    break
                }

            }
        .disposed(by: disposeBag)
    }
    
    func getLastSearch() -> String? {
        return StorageManager.shared.storage.lastSearch
    }

    @discardableResult
    private func updateFeaturedRepos() -> Bool {
        var hasUpdates = false
        let repositoriesNew = repositories.map {
            repository -> Repository in
            if StorageManager.shared.isRepoFeatured(repository) {
                repository.isFeatured = true
                hasUpdates = true
            }
            return repository
        }
        if hasUpdates {
            repositories = repositoriesNew
        }
        return hasUpdates
    }
    
}
