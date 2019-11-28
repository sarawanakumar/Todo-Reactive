//
//  Todo.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation

struct TodoElement: Codable {
    let id: Int
    let todoDescription, scheduledDate: String
    var status: String

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
        let completedTodos = todos.filter({$0.todoStatus == .completed})
        let pendingTodos = todos.filter({$0.todoStatus == .pending})

        return [.completed: completedTodos, .pending: pendingTodos]
    }


    enum TodoStatus {
        case completed
        case pending
    }

    enum CodingKeys: String, CodingKey {
        case id
        case todoDescription = "description"
        case scheduledDate, status
    }
}

typealias Todo = [TodoElement]
