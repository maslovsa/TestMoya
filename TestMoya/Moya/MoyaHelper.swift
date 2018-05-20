//
//  MoyaHelper.swift
//  TestMoya
//
//  Created by Sergey Maslov on 20.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import RxSwift

public extension URLEncoding {
    public static var queryCustomString: Alamofire.URLEncoding {
        return Alamofire.URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
    }
}

public struct MoyaTaskHelper {
    static func task(from array: [MyPoint]) -> Task {
        return .requestParameters(parameters: array.params, encoding: URLEncoding.queryCustomString)
    }
}

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
