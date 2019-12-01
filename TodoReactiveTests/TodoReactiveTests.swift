//
//  TodoReactiveTests.swift
//  TodoReactiveTests
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import XCTest
@testable import TodoReactive
import ReactiveSwift

class TodoReactiveTests: BaseViewModelTest {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewLoadingState() {
        perform(stub: { scheduler in
            return TodoViewModel(
                service: MockTodoService(),
                scheduler: scheduler
            )
        }, when: { (_, scheduler) in
            scheduler.advance()
        }) { (states) in
            XCTAssertEqual(states[0].items.count, 0)
            XCTAssertEqual(states[1].items.count, 2)
            XCTAssertEqual(states[1].items[.completed]?.count, 1)
            XCTAssertEqual(states[1].items[.pending]?.count, 1)
            XCTAssertEqual(states[1].items[.completed]?[0].id, 1)
            XCTAssertEqual(states[1].items[.pending]?[0].id, 2)
        }
    }
}

class MockTodoService: TodoServiceContract {
    func getTodoList() -> SignalProducer<Todo, Error> {
        return SignalProducer(value:
            [
                TodoElement(
                    id: 1,
                    todoDescription: "Task 1",
                    scheduledDate: "Dec 1",
                    status: "COMPLETED"
                ),
                TodoElement(
                    id: 2,
                    todoDescription: "Task 2",
                    scheduledDate: "Dec 2",
                    status: "PENDING"
                )
            ]
        )
    }
}
