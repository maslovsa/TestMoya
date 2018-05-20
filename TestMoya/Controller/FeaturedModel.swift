//
//  FeaturedModel.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation

protocol FeaturedModelInput: class {
    var output: FeaturedModelOutput? { get set }
    var repositories: Repositories { get }
    func viewDidLoad()
    func featureAction(repo: Repository)
}

protocol FeaturedModelOutput: class {
    func dataUpdated()
}

class FeaturedModel: FeaturedModelInput {
    var repositories = Repositories()
    weak var output: FeaturedModelOutput?
    
    func viewDidLoad() {
        repositories = StorageManager.shared.storage.featuredRepos
        output?.dataUpdated()
        
        StorageManager.shared.updateRepositorySignal.subscribePast(with: self) { [weak self](repo) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.repositories = StorageManager.shared.storage.featuredRepos
            strongSelf.output?.dataUpdated()
            }.onQueue(DispatchQueue.main)
    }
    
    func featureAction(repo: Repository) {
        StorageManager.shared.featureAction(repo: repo)
    }
}
