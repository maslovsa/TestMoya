//
//  DetailModel.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import Foundation

protocol DetailModelInput: class {
    var output: DetailModelOutput? { get set }
    var repo: Repository { get set }
    func getUserDetails()
    func viewDidLoad()
    func featureAction()
}

protocol DetailModelOutput: class {
    func detailsUpdated(isSuccess: Bool)
    func didStartSearch()
    func didFinishSearch()
}

class DetailModel: DetailModelInput {
    var repo = Repository()
    weak var output: DetailModelOutput?
    
    func viewDidLoad() {
        StorageManager.shared.updateRepositorySignal.subscribePast(with: self) { [weak self](repo) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.repo.id == repo.id {
                strongSelf.output?.detailsUpdated(isSuccess: true)
            }
        }.onQueue(DispatchQueue.main)
    }
    
    func getUserDetails() {
        guard let userName = repo.owner?.login else {
            output?.didFinishSearch()
            return
        }
        
        output?.didStartSearch()
        BackendManager.getUserDetails(username: userName) { [weak self](owner, error) in
            guard let strongSelf = self else {
                return
            }
            
            if let owner = owner, error == nil {
                strongSelf.repo.owner = owner
                strongSelf.output?.detailsUpdated(isSuccess: true)
                print("Repo Updated - \(strongSelf.repo.description)")
            } else {
                strongSelf.output?.detailsUpdated(isSuccess: false)
            }
            strongSelf.output?.didFinishSearch()
        }
    }
    
    func featureAction() {
        StorageManager.shared.featureAction(repo: self.repo)
    }
    
}
