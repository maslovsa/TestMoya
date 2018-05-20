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

public extension PrimitiveSequence where  TraitType == SingleTrait, ElementType == Response {

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
