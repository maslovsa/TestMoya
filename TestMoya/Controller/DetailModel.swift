//
//  DetailModel.swift
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

protocol DetailModelInput: class {
    var output: DetailModelOutput? { get set }
    var repo: Repository { get set }
    func getUserDetails()
    func viewDidLoad()
    func featureAction()
}

protocol DetailModelOutput: class {
    func didUpdateDetails()
    func didStartSearch()
    func didFinishSearch()
}

class DetailModel: DetailModelInput {
    var repo = Repository()
    weak var output: DetailModelOutput?
    private let provider = MoyaProvider<GitService>(plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: Constants.JSONResponseDataFormatter)])
    private let disposeBag = DisposeBag()

    func viewDidLoad() {
        StorageManager.shared.updateRepositorySignal.subscribePast(with: self) {
            [weak self] repo in

            if let strongSelf = self,
                strongSelf.repo.id == repo.id {
                strongSelf.output?.didUpdateDetails()
            }
            }.onQueue(DispatchQueue.main)
    }
    
    func getUserDetails() {
        guard let userName = repo.owner?.login else {
            output?.didFinishSearch()
            return
        }
        
        output?.didStartSearch()

        provider.rx.request(GitService.getUserDetails(userName: userName))
            .debug()
            .mapObject(OwnerDefinition.self)
            .subscribe {
                [weak self] event -> Void in

                self?.output?.didFinishSearch()

                guard let strongSelf = self else {
                    return
                }

                switch event {
                case .success(let owner):
                    strongSelf.repo.owner = owner
                    strongSelf.output?.didUpdateDetails()
                    print("Repo Updated - \(strongSelf.repo.description)")
                case .error(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func featureAction() {
        StorageManager.shared.featureAction(repo: self.repo)
    }
    
}
