//
//  DependerTests.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import XCTest
@testable import ItDepends

private final class Model1: Model {
    var a = 1
}

private final class Model2: Model {
    var a = 2
}

private final class Model3: Model {
    var a = 3
}

private struct DummyDepender: Depender {
    @Dependency var m1: Model1
    @Dependency var m2: Model2
    @Dependency var m3: Model3
}

class DependerTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() {
        let store = ModelStore(Model1.self, Model2.self, Model3.self)
        var depender = DummyDepender()
        depender.grabDependencies(from: store)
        XCTAssert(depender.m1.a == 1)
        XCTAssert(depender.m2.a == 2)
        XCTAssert(depender.m3.a == 3)
    }
}
