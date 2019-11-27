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

    var isTodoCompleted: Bool {
        get {
            if status == "COMPLETED" {
                return true
            }

            return false
        }
        set {
            status = newValue ? "COMPLETED" : "PENDING"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case todoDescription = "description"
        case scheduledDate, status
    }
}

typealias Todo = [TodoElement]
