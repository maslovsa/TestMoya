//
//  RxMoyaHelper.swift
//  TestMoya
//
//  Created by Sergey Maslov on 20.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Moya

public typealias ActivityProgressHandler = (Bool) -> Void

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    public func prepareArray(for keyPath: String) -> RxSwift.PrimitiveSequence<Trait, Element> {
        return flatMap { response -> RxSwift.PrimitiveSequence<Trait, Element> in

            guard let responseDict = try? response.mapJSON() as? [String: Any],
                let owner = responseDict?[keyPath] as? [Any],
                let newData = try? JSONSerialization.data(withJSONObject: owner, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                    return Single.just(response)
            }

            let newResponse = Response(statusCode: response.statusCode, data: newData, response: response.response)
            return Single.just(newResponse)
        }
    }
}

public extension RxSwift.ObservableType where E == Moya.ProgressResponse {

    // MARK: - Task 2
    public func trackActivity(with handler: ActivityProgressHandler?) -> Observable<E>  {
        return flatMap { progressResponse -> Observable<E> in
            handler?(progressResponse.completed)
            return Observable.just(progressResponse)
        }
    }

    public func prepareResponse(for keyPath: String) -> RxSwift.Observable<Moya.Response>  {
        return flatMap { progressResponse -> Observable<Moya.Response> in

            print(progressResponse.progress, progressResponse.completed)

            guard progressResponse.completed,
                let response = progressResponse.response,
                let responseDict = try? response.mapJSON() as? [String: Any],
                let owner = responseDict?[keyPath] as? [Any],
                let newData = try? JSONSerialization.data(withJSONObject: owner, options: JSONSerialization.WritingOptions.prettyPrinted) else {
                    return Observable.never()
            }

            let newResponse = Response(statusCode: response.statusCode, data: newData, response: response.response)
            return Observable.just(newResponse)
        }
    }
}
