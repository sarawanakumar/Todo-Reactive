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

    func testViewLoadingState() {
        perform(stub: { scheduler in
            return TodoViewModel(
                service: MockTodoService(shouldFailResponse: false),
                scheduler: scheduler
            )
        }, when: { (_, scheduler) in
            scheduler.advance()
        }) { states in
            XCTAssertEqual(states[0].items.count, 0)
            XCTAssertEqual(states[1].items.count, 2)
            XCTAssertEqual(states[1].items[.completed]?.count, 1)
            XCTAssertEqual(states[1].items[.pending]?.count, 1)
            XCTAssertEqual(states[1].items[.completed]?[0].id, 1)
            XCTAssertEqual(states[1].items[.pending]?[0].id, 2)
            XCTAssertEqual(states[1].pageStatus, .displayed)
        }
    }

    func testViewLoadingDidFail() {
        perform(stub: { (scheduler) -> TodoViewModel in
            TodoViewModel(
                service: MockTodoService(shouldFailResponse: true),
                scheduler: scheduler
            )
        }, when: { (_, scheduler) in
            scheduler.advance()
        }, assert: { states in
            XCTAssertEqual(states[1].items.count, 0)
            XCTAssertEqual(states[1].pageStatus, .failed("The operation couldn’t be completed. ( error 500.)"))
        })
    }
}

class MockTodoService: TodoServiceContract {
    private var shouldMockFailure = false

    init(shouldFailResponse: Bool) {
        shouldMockFailure = shouldFailResponse
    }

    func getTodoList() -> SignalProducer<Todo, Error> {
        if shouldMockFailure {
            return .init(
                error: NSError(
                    domain: "",
                    code: 500,
                    userInfo: nil
                )
            )
        }

        return .init(value:
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
