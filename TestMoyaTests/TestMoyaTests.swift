//
//  TestMoyaTests.swift
//  TestMoyaTests
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import XCTest
import Moya
@testable import TestMoya

class TestMoyaTests: XCTestCase {

    private var provider: MoyaProvider<MyService>!


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchSuccess() {
        let endpointClosure = { (target: MyService) -> Endpoint in
            return Endpoint(url: target.baseURL.absoluteString,
                            sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }

        provider = MoyaProvider<MyService>(endpointClosure: endpointClosure,
                                           stubClosure: MoyaProvider.immediatelyStub)

        provider.request(MyService.search(locations: [5.5, 6.6, 7.7, 8.8])) { result in
            if case .success(let moyaResponse) = result {
                XCTAssertEqual("test=5.5&test=6.6&test=7.7&test=8.8", String(data: moyaResponse.data, encoding: .utf8) ?? "empty", "Should equal")
                XCTAssertEqual(200, moyaResponse.statusCode, "Should be 200")
            } else {
                XCTFail("Should be without error")
            }
        }
    }

    func testSearchFailure() {
        let endpointClosure = { (target: MyService) -> Endpoint in
            let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "bad bad bad"] )
            return Endpoint(url: target.baseURL.absoluteString,
                            sampleResponseClosure: {.networkError(error) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }

        provider = MoyaProvider<MyService>(endpointClosure: endpointClosure,
                                           stubClosure: MoyaProvider.immediatelyStub)

        provider.request(MyService.search(locations: [1.1, 2.2, 3.3, 4.4])) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error, "Should be without error")
                XCTAssertEqual("bad bad bad", error.errorDescription ?? "empty", "Should equal")
            } else {
                XCTFail("Should be error")
            }
        }
    }

}
