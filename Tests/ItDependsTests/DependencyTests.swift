//
//  DependencyTests.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import XCTest
@testable import ItDepends

private final class DummyModel: Model {
    var a: Int
    
    init(a: Int) {
        self.a = a
    }
    
    init() {
        a = 5
    }
}

class DependencyTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() {
        @Dependency var dummy: DummyModel
        
        _dummy.resolve(with: DummyModel())
        XCTAssert(dummy.a == 5)
        
        _dummy.resolve(with: DummyModel(a: 6))
        XCTAssert(dummy.a == 6)
        
        dummy.a = 7
        XCTAssert(dummy.a == 7)
    }
}
