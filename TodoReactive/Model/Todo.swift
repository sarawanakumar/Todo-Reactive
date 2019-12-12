//
//  Todo.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation

typealias TodoStatus = TodoElement.TodoStatus

struct TodoElement: Codable {
    let id: Int
    let todoDescription, scheduledDate: String
    var status: String

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"

        guard let date = dateFormatter.date(from: scheduledDate) else { return "" }
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }

    var todoStatus: TodoStatus {
        get {
            if status == "COMPLETED" {
                return .completed
            }

            return .pending
        }
        set {
            status = newValue == .completed ? "COMPLETED" : "PENDING"
        }
    }

    static func arrangedTasks(todos: Todo) -> [TodoStatus: Todo] {
        let todos1 = TodoStatus.allCases.flatMap { status in
            [
                status: todos.filter({$0.todoStatus == status})
            ]
        }
        return Dictionary(todos1, uniquingKeysWith: {(first,_) in first})
    }


    enum TodoStatus: String, CaseIterable {
        case completed = "Completed"
        case pending = "Pending"

        mutating func toggle() {
            switch self {
            case .completed:
                self = .pending
            case .pending:
                self = .completed
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case todoDescription = "description"
        case scheduledDate, status
    }
}

typealias Todo = [TodoElement]
