//
//  QueryHelperTests.swift
//  TestMoyaTests
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import XCTest

class QueryHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let array = [1.1, 2.2, 3.3]
        XCTAssertEqual("points=1.1&points=2.2&points=3.3", array.composeQueue(with: "abba"))
    }
    
}
