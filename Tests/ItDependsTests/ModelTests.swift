//
//  ModelTests.swift
//  
//
//  Created by Ostap on 11.12.2021.
//

import XCTest
@testable import ItDepends

private final class TimerSettings: Model {
    @Dependency var taskStore: TaskStore
    var interval: TimeInterval = 15
}

private final class TaskStore: Model {
    @Dependency var modelStore: ModelStore
    var tasks = [1, 2, 3]
}

private final class HistoryStore: Model {
    var history = [4, 5, 6]
}

class ModelTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test() {
        let store = ModelStore(TimerSettings.self, TaskStore.self, HistoryStore.self)
        
        guard let taskStore = store.model(ofType: TaskStore.self) else {
            XCTAssert(false, "Missing TaskStore")
            return
        }
        XCTAssert(taskStore.modelStore === store)
        XCTAssert(taskStore.tasks == [1, 2, 3])
        
        guard let settings = store.model(ofType: TimerSettings.self) else {
            XCTAssert(false, "Missing TimerSettings")
            return
        }
        XCTAssert(settings.taskStore === taskStore)
        XCTAssert(settings.interval == 15)
        
        guard let historyStore = store.model(ofType: HistoryStore.self) else {
            XCTAssert(false, "Missing HistoryStore")
            return
        }
        XCTAssert(historyStore.history == [4, 5, 6])
    }
}

